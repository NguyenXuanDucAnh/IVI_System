#!/usr/bin/env python3
"""
bt_dbus_service.py

D-Bus service cho điều khiển Bluetooth Audio qua AVRCP
Có thể gọi từ Qt hoặc bất kỳ ứng dụng nào qua D-Bus

Service name: com.example.BluetoothAudio
Object path: /com/example/BluetoothAudio
Interface: com.example.BluetoothAudio
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
ADAPTER_PATH = "/org/bluez/hci0"

# D-Bus Service Configuration
DBUS_SERVICE_NAME = "com.example.BluetoothAudio"
DBUS_OBJECT_PATH = "/com/example/BluetoothAudio"
DBUS_INTERFACE = "com.example.BluetoothAudio"


# ---------------------------
# Helper: wpctl volume control
# ---------------------------
def wpctl_set_volume(value):
    """Set volume: value can be float '0.8' or '+0.1' or '-0.1'"""
    try:
        subprocess.run(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", str(value)], check=True)
        return True
    except subprocess.CalledProcessError as e:
        print("[VOL] wpctl failed:", e)
        return False

def wpctl_get_volume():
    try:
        out = subprocess.check_output(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"], text=True)
        # Parse output: "Volume: 0.50"
        parts = out.strip().split()
        if len(parts) >= 2:
            return float(parts[1])
        return 0.0
    except Exception as e:
        print("[VOL] wpctl get-volume failed:", e)
        return 0.0


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
        print(f"[AGENT] RequestConfirmation {device} passkey={passkey} -> Auto-confirm")
        return


# ---------------------------
# D-Bus Service for External Control
# ---------------------------
class BluetoothAudioService(dbus.service.Object):
    def __init__(self, bus, controller):
        self.controller = controller
        bus_name = dbus.service.BusName(DBUS_SERVICE_NAME, bus=bus)
        super().__init__(bus_name, DBUS_OBJECT_PATH)
        print(f"[DBUS] Service registered: {DBUS_SERVICE_NAME} at {DBUS_OBJECT_PATH}")

    @dbus.service.method(DBUS_INTERFACE, out_signature='b')
    def Play(self):
        """Play audio"""
        try:
            self.controller.avrcp_command("Play")
            return True
        except Exception as e:
            print("[DBUS] Play error:", e)
            return False

    @dbus.service.method(DBUS_INTERFACE, out_signature='b')
    def Pause(self):
        """Pause audio"""
        try:
            self.controller.avrcp_command("Pause")
            return True
        except Exception as e:
            print("[DBUS] Pause error:", e)
            return False

    @dbus.service.method(DBUS_INTERFACE, out_signature='b')
    def PlayPause(self):
        """Toggle play/pause"""
        try:
            if self.controller.player_path:
                obj = self.controller.bus.get_object(BLUEZ_SERVICE, self.controller.player_path)
                props = dbus.Interface(obj, "org.freedesktop.DBus.Properties")
                try:
                    status = props.Get(PLAYER_IFACE, "Status")
                    if status.lower() == "playing":
                        self.controller.avrcp_command("Pause")
                    else:
                        self.controller.avrcp_command("Play")
                    return True
                except Exception:
                    self.controller.avrcp_command("Play")
                    return True
            return False
        except Exception as e:
            print("[DBUS] PlayPause error:", e)
            return False

    @dbus.service.method(DBUS_INTERFACE, out_signature='b')
    def Next(self):
        """Next track"""
        try:
            self.controller.avrcp_command("Next")
            return True
        except Exception as e:
            print("[DBUS] Next error:", e)
            return False

    @dbus.service.method(DBUS_INTERFACE, out_signature='b')
    def Previous(self):
        """Previous track"""
        try:
            self.controller.avrcp_command("Previous")
            return True
        except Exception as e:
            print("[DBUS] Previous error:", e)
            return False

    @dbus.service.method(DBUS_INTERFACE, in_signature='d', out_signature='b')
    def SetVolume(self, volume):
        """Set volume (0.0 to 1.0)"""
        try:
            return wpctl_set_volume(str(volume))
        except Exception as e:
            print("[DBUS] SetVolume error:", e)
            return False

    @dbus.service.method(DBUS_INTERFACE, out_signature='b')
    def VolumeUp(self):
        """Increase volume by 0.1"""
        try:
            return wpctl_set_volume("+0.1")
        except Exception as e:
            print("[DBUS] VolumeUp error:", e)
            return False

    @dbus.service.method(DBUS_INTERFACE, out_signature='b')
    def VolumeDown(self):
        """Decrease volume by 0.1"""
        try:
            return wpctl_set_volume("-0.1")
        except Exception as e:
            print("[DBUS] VolumeDown error:", e)
            return False

    @dbus.service.method(DBUS_INTERFACE, out_signature='d')
    def GetVolume(self):
        """Get current volume (0.0 to 1.0)"""
        try:
            return wpctl_get_volume()
        except Exception as e:
            print("[DBUS] GetVolume error:", e)
            return 0.0

    @dbus.service.method(DBUS_INTERFACE, out_signature='a{ss}')
    def GetMetadata(self):
        """Get current track metadata"""
        try:
            metadata = {}
            if self.controller.player_path:
                obj = self.controller.bus.get_object(BLUEZ_SERVICE, self.controller.player_path)
                props = dbus.Interface(obj, "org.freedesktop.DBus.Properties")
                track = props.Get(PLAYER_IFACE, "Track")
                metadata = {
                    "Title": str(track.get("Title", "Unknown")),
                    "Artist": str(track.get("Artist", "Unknown")),
                    "Album": str(track.get("Album", "Unknown"))
                }
            return metadata
        except Exception as e:
            print("[DBUS] GetMetadata error:", e)
            return {}

    @dbus.service.method(DBUS_INTERFACE, out_signature='s')
    def GetStatus(self):
        """Get player status (playing/paused/stopped)"""
        try:
            if self.controller.player_path:
                obj = self.controller.bus.get_object(BLUEZ_SERVICE, self.controller.player_path)
                props = dbus.Interface(obj, "org.freedesktop.DBus.Properties")
                status = props.Get(PLAYER_IFACE, "Status")
                return str(status)
            return "disconnected"
        except Exception as e:
            print("[DBUS] GetStatus error:", e)
            return "error"

    @dbus.service.signal(DBUS_INTERFACE, signature='a{ss}')
    def MetadataChanged(self, metadata):
        """Signal emitted when track changes"""
        pass

    @dbus.service.signal(DBUS_INTERFACE, signature='s')
    def StatusChanged(self, status):
        """Signal emitted when player status changes"""
        pass


# ---------------------------
# Main Controller
# ---------------------------
class BTController:
    def __init__(self):
        dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
        self.bus = dbus.SystemBus()
        self.session_bus = dbus.SessionBus()
        self.om = dbus.Interface(self.bus.get_object(BLUEZ_SERVICE, "/"),
                                 "org.freedesktop.DBus.ObjectManager")
        self.adapter_path = ADAPTER_PATH
        self.player_path = None
        self.device_path = None
        self.dbus_service = None

        # Register agent
        self.register_agent()

        # Setup adapter
        self.setup_adapter()

        # Register D-Bus service on session bus
        self.dbus_service = BluetoothAudioService(self.session_bus, self)

        # Listen signals
        self.bus.add_signal_receiver(self.interfaces_added,
                                     dbus_interface="org.freedesktop.DBus.ObjectManager",
                                     signal_name="InterfacesAdded")
        self.bus.add_signal_receiver(self.properties_changed,
                                     dbus_interface="org.freedesktop.DBus.Properties",
                                     signal_name="PropertiesChanged",
                                     path_keyword="path")

        # Start scan thread
        self.scan_thread = threading.Thread(target=self.scan_loop, daemon=True)
        self.scan_thread.start()

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

    def setup_adapter(self):
        try:
            adapter_obj = self.bus.get_object(BLUEZ_SERVICE, self.adapter_path)
            adapter_props = dbus.Interface(adapter_obj, "org.freedesktop.DBus.Properties")
            adapter_props.Set(ADAPTER_IFACE, "Powered", dbus.Boolean(1))
            adapter_props.Set(ADAPTER_IFACE, "Pairable", dbus.Boolean(1))
            adapter_props.Set(ADAPTER_IFACE, "Discoverable", dbus.Boolean(1))
            adapter_props.Set(ADAPTER_IFACE, "DiscoverableTimeout", dbus.UInt32(0))
            print("[ADAPTER] Set Powered, Pairable, Discoverable (timeout=0)")
        except Exception as e:
            print("[ADAPTER] Cannot set adapter properties:", e)

    def interfaces_added(self, object_path, interfaces):
        if DEVICE_IFACE in interfaces:
            props = interfaces[DEVICE_IFACE]
            addr = props.get("Address", "unknown")
            name = props.get("Name", "")
            connected = props.get("Connected", False)
            print(f"[EVENT] New Device Added: {name} {addr} connected={connected} path={object_path}")
            if connected:
                self.maybe_setup_device(object_path)

        if PLAYER_IFACE in interfaces:
            print("[EVENT] MediaPlayer appeared:", object_path)
            self.player_path = object_path
            self.print_metadata_for(player_path=object_path)

    def properties_changed(self, interface, changed, invalidated, path):
        if interface == DEVICE_IFACE:
            if "Connected" in changed:
                connected = bool(changed["Connected"])
                print(f"[DEVICE] {path} Connected={connected}")
                if connected:
                    self.auto_pair_trust(path)
                    player = self.find_media_player_for_device(path)
                    if player:
                        self.player_path = player
                        print("[DEVICE] Found MediaPlayer:", player)
                        self.print_metadata_for(player)
                else:
                    if self.device_path == path:
                        print("[DEVICE] Device disconnected:", path)
                        self.device_path = None
                        self.player_path = None
                        if self.dbus_service:
                            self.dbus_service.StatusChanged("disconnected")

        elif interface == "org.bluez.MediaPlayer1":
            if "Track" in changed:
                metadata = changed["Track"]
                self.handle_track_changed(metadata)
            if "Status" in changed:
                status = changed["Status"]
                print("[PLAYER] Status:", status)
                if self.dbus_service:
                    self.dbus_service.StatusChanged(str(status))

    def scan_loop(self):
        print("[SCAN] Starting scan loop...")
        while True:
            try:
                objects = self.om.GetManagedObjects()
                for path, ifaces in objects.items():
                    if DEVICE_IFACE in ifaces:
                        props = ifaces[DEVICE_IFACE]
                        if props.get("Connected", False):
                            self.auto_pair_trust(path)
                            player = self.find_media_player_for_device(path)
                            if player:
                                if self.player_path != player:
                                    print("[SCAN] Detected player for device:", path, "->", player)
                                self.player_path = player
                                self.device_path = path
                                self.print_metadata_for(player)
                time.sleep(2)
            except Exception as e:
                print("[SCAN] Exception in scan_loop:", e)
                time.sleep(2)

    def auto_pair_trust(self, device_path):
        try:
            dev_obj = self.bus.get_object(BLUEZ_SERVICE, device_path)
            dev_methods = dbus.Interface(dev_obj, DEVICE_IFACE)
            dev_props = dbus.Interface(dev_obj, "org.freedesktop.DBus.Properties")

            try:
                dev_props.Set(DEVICE_IFACE, "Trusted", dbus.Boolean(1))
                print(f"[AUTO] Set Trusted for {device_path}")
            except Exception as e:
                print("[AUTO] Could not set Trusted property:", e)

            paired = bool(dev_props.Get(DEVICE_IFACE, "Paired"))
            if not paired:
                try:
                    print("[AUTO] Attempting Pair() to", device_path)
                    dev_methods.Pair()
                    print("[AUTO] Pair() finished for", device_path)
                except Exception as e:
                    print("[AUTO] Pair() error:", e)

            connected = bool(dev_props.Get(DEVICE_IFACE, "Connected"))
            if not connected:
                try:
                    print("[AUTO] Attempting Connect() to", device_path)
                    dev_methods.Connect()
                    print("[AUTO] Connect() finished for", device_path)
                except Exception as e:
                    print("[AUTO] Connect() error:", e)

        except Exception as e:
            print("[AUTO] auto_pair_trust exception:", e)

    def find_media_player_for_device(self, device_path):
        objects = self.om.GetManagedObjects()
        for path, ifaces in objects.items():
            if PLAYER_IFACE in ifaces:
                if device_path in path:
                    return path
        return None

    def maybe_setup_device(self, device_path):
        print("[SETUP] maybe_setup_device called for", device_path)
        self.auto_pair_trust(device_path)
        player = self.find_media_player_for_device(device_path)
        if player:
            self.player_path = player
            self.device_path = device_path
            self.print_metadata_for(player)

    def print_metadata_for(self, player_path=None):
        if not player_path and not self.player_path:
            print("[META] No player available")
            return
        path = player_path or self.player_path
        try:
            obj = self.bus.get_object(BLUEZ_SERVICE, path)
            props = dbus.Interface(obj, "org.freedesktop.DBus.Properties")
            track = props.Get(PLAYER_IFACE, "Track")
            metadata = {
                "Title": str(track.get("Title", "Unknown")),
                "Artist": str(track.get("Artist", "Unknown")),
                "Album": str(track.get("Album", "Unknown"))
            }
            print("[META] Now playing:")
            print(f"  Title : {metadata['Title']}")
            print(f"  Artist: {metadata['Artist']}")
            print(f"  Album : {metadata['Album']}")
            
            if self.dbus_service:
                self.dbus_service.MetadataChanged(metadata)
        except Exception as e:
            print("[META] Failed to read metadata:", e)

    def handle_track_changed(self, track):
        metadata = {
            "Title": str(track.get("Title", "Unknown")),
            "Artist": str(track.get("Artist", "Unknown")),
            "Album": str(track.get("Album", "Unknown"))
        }
        print("[META] Track changed:")
        print(f"  Title : {metadata['Title']}")
        print(f"  Artist: {metadata['Artist']}")
        print(f"  Album : {metadata['Album']}")
        
        if self.dbus_service:
            self.dbus_service.MetadataChanged(metadata)

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


def turn_off_bluetooth(sig, frame):
    print("\n[CTRL+C] Stopping... Cleaning up Bluetooth")
    subprocess.call("bluetoothctl power off", shell=True)
    print("[EXIT] Done.")
    sys.exit(0)


def main():
    # không chạy lệnh này thì nó bị lock rf kill
    try:
        print ("Run rf kill")
        subprocess.run(["rfkill", "unblock", "bluetooth"], check=True)
    except:
        print ("except when run rfkill")


    print("=" * 60)
    print("Bluetooth Audio D-Bus Service")
    print(f"Service: {DBUS_SERVICE_NAME}")
    print(f"Object: {DBUS_OBJECT_PATH}")
    print(f"Interface: {DBUS_INTERFACE}")
    print("=" * 60)
    
    ctrl = BTController()
    
    try:
        signal.signal(signal.SIGINT, turn_off_bluetooth)
        loop = GLib.MainLoop()
        loop.run()
    except KeyboardInterrupt:
        print("Interrupted. Exiting...")


if __name__ == "__main__":
    main()