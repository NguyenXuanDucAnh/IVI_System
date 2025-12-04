
# chạy lệnh sau ở terminal: bluetoothctl
# [bluetooth]# power on
# Changing power on succeeded
# [bluetooth]# agent on
# Agent is already registered
# [bluetooth]# default-agent
# Default agent request successful
# [bluetooth]# discoverable on
# Changing discoverable on succeeded
# [CHG] Controller 2C:CF:67:35:A2:72 Discoverable: yes
# [bluetooth]# pairable on
# Changing pairable on succeeded
# [bluetooth]# scan on


#!/usr/bin/env python3
"""
bt_agent_full.py

- Auto-scan devices
- Auto-pair & auto-trust
- Monitor AVRCP metadata (MediaPlayer1) and print Title/Artist/Album
- Play/Pause control via AVRCP
- Volume control via wpctl (PipeWire)
"""

import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib
import subprocess
import threading
import time
import sys
import signal


BLUEZ_SERVICE = "org.bluez"
ADAPTER_IFACE = "org.bluez.Adapter1"
DEVICE_IFACE = "org.bluez.Device1"
PLAYER_IFACE = "org.bluez.MediaPlayer1"
AGENT_IFACE = "org.bluez.Agent1"
AGENT_MANAGER = "org.bluez.AgentManager1"
AGENT_PATH = "/com/example/AutoAgent"
ADAPTER_PATH = "/org/bluez/hci0"   # adjust if adapter name differs

# ---------------------------
# Helper: call wpctl to change volume
# ---------------------------
def wpctl_set_volume(value):
    """Set volume: value can be float '0.8' or '+0.1' or '-0.1'"""
    try:
        subprocess.run(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", str(value)], check=True)
    except subprocess.CalledProcessError as e:
        print("[VOL] wpctl failed:", e)

def wpctl_get_volume():
    try:
        out = subprocess.check_output(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"], text=True)
        print("[VOL] current:", out.strip())
    except Exception as e:
        print("[VOL] wpctl get-volume failed:", e)

# ---------------------------
# BlueZ Agent Implementation
# ---------------------------
class AutoAgent(dbus.service.Object):
    def __init__(self, bus, path=AGENT_PATH):
        super().__init__(bus, path)
        print("[AGENT] AutoAgent created at", path)

    @dbus.service.method(AGENT_IFACE, in_signature="", out_signature="")
    def Release(self):
        print("[AGENT] Release called")

    @dbus.service.method(AGENT_IFACE, in_signature="o", out_signature="")
    def RequestAuthorization(self, device):
        print("[AGENT] RequestAuthorization for", device)
        # Auto-authorize
        return

    @dbus.service.method(AGENT_IFACE, in_signature="o", out_signature="s")
    def RequestPinCode(self, device):
        print("[AGENT] RequestPinCode for", device, "-> returning '0000'")
        return "0000"

    @dbus.service.method(AGENT_IFACE, in_signature="o", out_signature="u")
    def RequestPasskey(self, device):
        print("[AGENT] RequestPasskey for", device, "-> returning 0")
        return dbus.UInt32(0)

    @dbus.service.method(AGENT_IFACE, in_signature="ou", out_signature="")
    def DisplayPasskey(self, device, passkey):
        print(f"[AGENT] DisplayPasskey {device} {passkey}")

    @dbus.service.method(AGENT_IFACE, in_signature="os", out_signature="")
    def DisplayPinCode(self, device, pincode):
        print(f"[AGENT] DisplayPinCode {device} {pincode}")

    @dbus.service.method(AGENT_IFACE, in_signature="o", out_signature="")
    def RequestCancel(self, device):
        print("[AGENT] RequestCancel", device)

    @dbus.service.method(AGENT_IFACE, in_signature="ou", out_signature="")
    def RequestConfirmation(self, device, passkey):
        # auto-confirm
        print(f"[AGENT] RequestConfirmation {device} passkey={passkey} -> Auto-confirm")
        return

# ---------------------------
# Main Controller
# ---------------------------
class BTController:
    def __init__(self):
        dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
        self.bus = dbus.SystemBus()
        self.om = dbus.Interface(self.bus.get_object(BLUEZ_SERVICE, "/"),
                                 "org.freedesktop.DBus.ObjectManager")
        self.adapter_path = ADAPTER_PATH
        self.player_path = None
        self.device_path = None

        # Register agent
        self.register_agent()

        # Make adapter discoverable & pairable
        self.setup_adapter()

        # Listen signals for InterfacesAdded, PropertiesChanged
        self.bus.add_signal_receiver(self.interfaces_added,
                                     dbus_interface="org.freedesktop.DBus.ObjectManager",
                                     signal_name="InterfacesAdded")
        self.bus.add_signal_receiver(self.properties_changed,
                                     dbus_interface="org.freedesktop.DBus.Properties",
                                     signal_name="PropertiesChanged",
                                     path_keyword="path")

        # start a background thread to scan for connected devices that have MediaPlayer
        self.scan_thread = threading.Thread(target=self.scan_loop, daemon=True)
        self.scan_thread.start()

    # ---------------------------
    # Agent registration
    # ---------------------------
    def register_agent(self):
        try:
            manager = dbus.Interface(self.bus.get_object(BLUEZ_SERVICE, "/org/bluez"),
                                     AGENT_MANAGER)
            self.agent = AutoAgent(self.bus, AGENT_PATH)
            manager.RegisterAgent(AGENT_PATH, "NoInputNoOutput")
            manager.RequestDefaultAgent(AGENT_PATH)
            print("[AGENT] Registered AutoAgent as default (NoInputNoOutput)")
        except Exception as e:
            print("[AGENT] Failed to register agent:", e)

    # ---------------------------
    # Adapter setup
    # ---------------------------
    def setup_adapter(self):
        try:
            adapter_obj = self.bus.get_object(BLUEZ_SERVICE, self.adapter_path)
            adapter_props = dbus.Interface(adapter_obj, "org.freedesktop.DBus.Properties")
            # set adapter discoverable & pairable
            adapter_props.Set(ADAPTER_IFACE, "Powered", dbus.Boolean(1))
            adapter_props.Set(ADAPTER_IFACE, "Pairable", dbus.Boolean(1))
            adapter_props.Set(ADAPTER_IFACE, "Discoverable", dbus.Boolean(1))
            adapter_props.Set(ADAPTER_IFACE, "DiscoverableTimeout", dbus.UInt32(0))
            print("[ADAPTER] Set Powered, Pairable, Discoverable (timeout=0)")
        except Exception as e:
            print("[ADAPTER] Cannot set adapter properties:", e)

    # ---------------------------
    # Signals
    # ---------------------------
    def interfaces_added(self, object_path, interfaces):
        # called when new object appears (device or media player)
        # interfaces: dict mapping iface->props
        # print("[SIGNAL] InterfacesAdded:", object_path, interfaces.keys())
        if DEVICE_IFACE in interfaces:
            props = interfaces[DEVICE_IFACE]
            addr = props.get("Address", "unknown")
            name = props.get("Name", "")
            connected = props.get("Connected", False)
            print(f"[EVENT] New Device Added: {name} {addr} connected={connected} path={object_path}")
            # if device appears and connected, attempt pairing/trust/connect
            if not connected:
                # not connected yet; nothing to do until connect event or pair request
                pass
            else:
                # device connected; try find player
                self.maybe_setup_device(object_path)

        if PLAYER_IFACE in interfaces:
            # a MediaPlayer appeared (likely AVRCP)
            print("[EVENT] MediaPlayer appeared:", object_path)
            # link to device path
            self.player_path = object_path
            # print metadata immediately
            self.print_metadata_for(player_path=object_path)

    def properties_changed(self, interface, changed, invalidated, path):
        # called for many objects; filter relevant ones
        # print("[SIGPROP] path:", path, "interface:", interface, "changed:", changed)
        if interface == DEVICE_IFACE:
            # device property change, e.g., Connected true/false
            if "Connected" in changed:
                connected = bool(changed["Connected"])
                print(f"[DEVICE] {path} Connected={connected}")
                if connected:
                    # attempt trust/pair if needed
                    self.auto_pair_trust(path)
                    # try to find media player under this device
                    player = self.find_media_player_for_device(path)
                    if player:
                        self.player_path = player
                        print("[DEVICE] Found MediaPlayer:", player)
                        self.print_metadata_for(player)
                else:
                    # disconnected
                    if self.device_path == path:
                        print("[DEVICE] Device disconnected:", path)
                        self.device_path = None
                        self.player_path = None

        elif interface == "org.bluez.MediaPlayer1":
            # metadata changes when track changes
            if "Track" in changed:
                metadata = changed["Track"]
                self.handle_track_changed(metadata)
            if "Status" in changed:
                status = changed["Status"]
                print("[PLAYER] Status:", status)

    # ---------------------------
    # Scanning loop: look for connected devices and players
    # ---------------------------
    def scan_loop(self):
        # prefer when device is already connected; otherwise ensure adapter is discoverable for pairing
        print("[SCAN] Starting scan loop (monitor for connected devices / MediaPlayers)...")
        while True:
            try:
                objects = self.om.GetManagedObjects()
                # check for any connected device with MediaPlayer
                for path, ifaces in objects.items():
                    if DEVICE_IFACE in ifaces:
                        props = ifaces[DEVICE_IFACE]
                        if props.get("Connected", False):
                            # ensure trusted
                            self.auto_pair_trust(path)
                            player = self.find_media_player_for_device(path)
                            if player:
                                if self.player_path != player:
                                    print("[SCAN] Detected player for device:", path, "->", player)
                                self.player_path = player
                                self.device_path = path
                                # print metadata
                                self.print_metadata_for(player)
                                # keep monitoring; don't exit
                time.sleep(2)
            except Exception as e:
                print("[SCAN] Exception in scan_loop:", e)
                time.sleep(2)

    # ---------------------------
    # Auto Pair & Trust & Connect
    # ---------------------------
    def auto_pair_trust(self, device_path):
        try:
            dev_obj = self.bus.get_object(BLUEZ_SERVICE, device_path)
            dev_methods = dbus.Interface(dev_obj, DEVICE_IFACE)
            dev_props = dbus.Interface(dev_obj, "org.freedesktop.DBus.Properties")

            # Set Trusted = True
            try:
                dev_props.Set(DEVICE_IFACE, "Trusted", dbus.Boolean(1))
                print(f"[AUTO] Set Trusted for {device_path}")
            except Exception as e:
                print("[AUTO] Could not set Trusted property:", e)

            # If not paired (Paired property), try pair
            paired = bool(dev_props.Get(DEVICE_IFACE, "Paired"))
            if not paired:
                try:
                    print("[AUTO] Attempting Pair() to", device_path)
                    dev_methods.Pair()
                    print("[AUTO] Pair() finished for", device_path)
                except Exception as e:
                    print("[AUTO] Pair() error (may already be paired or require agent):", e)

            # If not connected, attempt connect (so audio profiles attach)
            connected = bool(dev_props.Get(DEVICE_IFACE, "Connected"))
            if not connected:
                try:
                    print("[AUTO] Attempting Connect() to", device_path)
                    dev_methods.Connect()
                    print("[AUTO] Connect() finished for", device_path)
                except Exception as e:
                    print("[AUTO] Connect() error (may be normal):", e)

        except Exception as e:
            print("[AUTO] auto_pair_trust exception:", e)

    # ---------------------------
    # Helper: find MediaPlayer for device
    # ---------------------------
    def find_media_player_for_device(self, device_path):
        objects = self.om.GetManagedObjects()
        for path, ifaces in objects.items():
            if PLAYER_IFACE in ifaces:
                if device_path in path:
                    return path
        return None

    # ---------------------------
    # Maybe setup device when added connected
    # ---------------------------
    def maybe_setup_device(self, device_path):
        print("[SETUP] maybe_setup_device called for", device_path)
        # do auto pair/trust and connect
        self.auto_pair_trust(device_path)
        player = self.find_media_player_for_device(device_path)
        if player:
            self.player_path = player
            self.device_path = device_path
            self.print_metadata_for(player)

    # ---------------------------
    # Print metadata helper
    # ---------------------------
    def print_metadata_for(self, player_path=None):
        if not player_path and not self.player_path:
            print("[META] No player available")
            return
        path = player_path or self.player_path
        try:
            obj = self.bus.get_object(BLUEZ_SERVICE, path)
            props = dbus.Interface(obj, "org.freedesktop.DBus.Properties")
            track = props.Get(PLAYER_IFACE, "Track")
            print("[META] Now playing:")
            print("  Title :", track.get("Title", "Unknown"))
            print("  Artist:", track.get("Artist", "Unknown"))
            print("  Album :", track.get("Album", "Unknown"))
        except Exception as e:
            print("[META] Failed to read metadata:", e)

    def handle_track_changed(self, track):
        print("[META] Track changed:")
        print("  Title :", track.get("Title", "Unknown"))
        print("  Artist:", track.get("Artist", "Unknown"))
        print("  Album :", track.get("Album", "Unknown"))

    # ---------------------------
    # AVRCP controls (Play/Pause/Next/Prev)
    # ---------------------------
    def avrcp_command(self, cmd):
        if not self.player_path:
            print("[AVRCP] No player connected")
            return
        try:
            obj = self.bus.get_object(BLUEZ_SERVICE, self.player_path)
            player = dbus.Interface(obj, PLAYER_IFACE)
            if hasattr(player, cmd):
                getattr(player, cmd)()
                print("[AVRCP] Sent", cmd)
            else:
                print("[AVRCP] Player has no method", cmd)
        except Exception as e:
            print("[AVRCP] Error sending cmd:", e)


def Turn_Off_Bluetooh (sig, frame):
    print("\n[CTRL+C] Stopping... Cleaning up Bluetooth")
    subprocess.call("bluetoothctl power off", shell=True)
    print("[EXIT] Done.")
    sys.exit(0)

# ---------------------------
# CLI thread to accept commands from user
# ---------------------------
def cli_loop(controller):
    help_text = """
Commands:
  p      : toggle play/pause
  play   : play
  pause  : pause
  next   : next track
  prev   : previous track
  vol+   : volume up 0.1
  vol-   : volume down 0.1
  vol X  : set volume to X (0.0 - 1.0)
  vol?   : get current volume (wpctl)
  meta   : print current metadata
  q      : quit
  h      : help
"""
    print(help_text)
    # keep simple: read from stdin
    playing_state = None
    while True:
        try:

            cmd = sys.stdin.readline()
            if not cmd:
                time.sleep(0.1)
                continue
            cmd = cmd.strip()
            if cmd == "":
                continue
            if cmd == "q":
                print("Quitting...")
                GLib.MainLoop().quit()
                break
            elif cmd == "p":
                # toggle via reading Status if possible
                if controller.player_path:
                    obj = controller.bus.get_object(BLUEZ_SERVICE, controller.player_path)
                    props = dbus.Interface(obj, "org.freedesktop.DBus.Properties")
                    try:
                        status = props.Get(PLAYER_IFACE, "Status")
                        if status.lower() == "playing":
                            controller.avrcp_command("Pause")
                        else:
                            controller.avrcp_command("Play")
                    except Exception:
                        controller.avrcp_command("Play")
                else:
                    print("[CLI] No player")
            elif cmd == "play":
                controller.avrcp_command("Play")
            elif cmd == "pause":
                controller.avrcp_command("Pause")
            elif cmd == "next":
                controller.avrcp_command("Next")
            elif cmd == "prev":
                controller.avrcp_command("Previous")
            elif cmd == "vol+":
                wpctl_set_volume("+0.1")
            elif cmd == "vol-":
                wpctl_set_volume("-0.1")
            elif cmd.startswith("vol "):
                _, val = cmd.split(None, 1)
                wpctl_set_volume(val)
            elif cmd == "vol?":
                wpctl_get_volume()
            elif cmd == "meta":
                controller.print_metadata_for()
            elif cmd == "h":
                print(help_text)
            else:
                print("[CLI] Unknown command. h for help.")
        except Exception as e:
            print("[CLI] Exception:", e)
            time.sleep(0.1)

# ---------------------------
# Entrypoint
# ---------------------------
def main():
    ctrl = BTController()
    # start CLI in background thread so mainloop still runs
    t = threading.Thread(target=cli_loop, args=(ctrl,), daemon=True)
    t.start()
    try:
        # CTRL+C handler
        signal.signal(signal.SIGINT, Turn_Off_Bluetooh) # nếu nhấn ctrl + c để kill chương trình thì tiến hành tắt bluetooth
        loop = GLib.MainLoop()
        loop.run()
    except KeyboardInterrupt:
        print("Interrupted. Exiting...")

if __name__ == "__main__":
    main()
