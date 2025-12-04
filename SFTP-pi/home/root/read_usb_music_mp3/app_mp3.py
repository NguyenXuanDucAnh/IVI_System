# #!/usr/bin/env python3
# import gi
# gi.require_version("Gst", "1.0")
# from gi.repository import Gst, GLib
# import sys

# Gst.init()

# if len(sys.argv) < 2:
#     print("Usage: python3 play_mp3.py file.mp3")
#     sys.exit(1)

# mp3_file = sys.argv[1]

# pipeline_str = (
#     f"filesrc location={mp3_file} ! "
#     "decodebin ! audioconvert ! audioresample ! volume volume=10.0 ! autoaudiosink"
# )

# pipeline = Gst.parse_launch(pipeline_str)

# loop = GLib.MainLoop()

# def on_message(bus, message, loop):
#     if message.type == Gst.MessageType.EOS:
#         print("Playback finished")
#         loop.quit()
#     elif message.type == Gst.MessageType.ERROR:
#         err, _ = message.parse_error()
#         print(f"Error: {err}")
#         loop.quit()

# bus = pipeline.get_bus()
# bus.add_signal_watch()
# bus.connect("message", on_message, loop)

# pipeline.set_state(Gst.State.PLAYING)

# print(">>> Playing...")
# try:
#     loop.run()
# except KeyboardInterrupt:
#     pass

# pipeline.set_state(Gst.State.NULL)



# #!/usr/bin/env python3
# import os
# import sys
# import gi
# import threading

# gi.require_version("Gst", "1.0")
# from gi.repository import Gst, GLib

# import dbus
# import dbus.service
# import dbus.mainloop.glib

# Gst.init()

# MUSIC_FOLDER = "/home/root/read_usb_music_mp3"

# pipeline = None
# loop = None
# current_volume = 1.0


# # =====================================================
# #  D-Bus Service
# # =====================================================
# class MusicService(dbus.service.Object):
#     DBUS_NAME = "org.example.Music"
#     DBUS_PATH = "/org/example/Music"

#     def __init__(self, bus):
#         super().__init__(bus, self.DBUS_PATH)

#     # ------------------- List Songs --------------------
#     @dbus.service.method(DBUS_NAME, out_signature="as")
#     def ListSongs(self):
#         files = [
#             f for f in os.listdir(MUSIC_FOLDER)
#             if f.lower().endswith(".mp3")
#         ]
#         return files

#     # ------------------- Play Song ---------------------
#     @dbus.service.method(DBUS_NAME, in_signature="s")
#     def Play(self, song):
#         global pipeline, loop, current_volume

#         stop_pipeline()

#         filepath = os.path.join(MUSIC_FOLDER, song)

#         if not os.path.exists(filepath):
#             print(f"ERROR: File not found {filepath}")
#             return

#         print(f"PLAY: {filepath}")

#         pipeline_str = (
#             f"filesrc location=\"{filepath}\" ! "
#             "decodebin ! audioconvert ! audioresample ! "
#             f"volume volume={current_volume} ! autoaudiosink"
#         )

#         pipeline = Gst.parse_launch(pipeline_str)

#         def gst_thread():
#             global loop
#             loop = GLib.MainLoop()

#             bus = pipeline.get_bus()
#             bus.add_signal_watch()
#             bus.connect("message", on_message, loop)

#             pipeline.set_state(Gst.State.PLAYING)

#             try:
#                 loop.run()
#             except KeyboardInterrupt:
#                 pass

#             pipeline.set_state(Gst.State.NULL)

#         t = threading.Thread(target=gst_thread, daemon=True)
#         t.start()

#     # ------------------- Set Volume --------------------
#     @dbus.service.method(DBUS_NAME, in_signature="d")
#     def SetVolume(self, value):
#         global current_volume, pipeline

#         current_volume = float(value)

#         if pipeline:
#             for elem in pipeline.iterate_elements():
#                 try:
#                     if elem.get_factory().get_name() == "volume":
#                         elem.set_property("volume", current_volume)
#                         break
#                 except:
#                     pass

#         print(f"VOLUME = {current_volume}")


# # =====================================================
# #  Helper Functions
# # =====================================================
# def stop_pipeline():
#     global pipeline, loop

#     if pipeline:
#         pipeline.set_state(Gst.State.NULL)
#         pipeline = None

#     if loop:
#         loop.quit()
#         loop = None


# def on_message(bus, message, loop):
#     if message.type == Gst.MessageType.EOS:
#         print("FINISHED.")
#         loop.quit()
#     elif message.type == Gst.MessageType.ERROR:
#         err, _ = message.parse_error()
#         print(f"ERROR: {err}")
#         loop.quit()


# # =====================================================
# #  MAIN SERVICE ENTRY
# # =====================================================
# if __name__ == "__main__":
#     dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

#     system_bus = dbus.SystemBus()

#     name = dbus.service.BusName(
#         MusicService.DBUS_NAME,
#         bus=system_bus
#     )

#     service = MusicService(system_bus)

#     print("D-BUS Music Service running...")
#     GLib.MainLoop().run()



#!/usr/bin/env python3
import os
import gi
import threading

gi.require_version("Gst", "1.0")
from gi.repository import Gst, GLib

import dbus
import dbus.service
import dbus.mainloop.glib

Gst.init()

MUSIC_FOLDER = "/home/root/read_usb_music_mp3"

pipeline = None
loop = None
current_volume = 1.0

# =====================================================
#  Helper Functions
# =====================================================
def stop_pipeline():
    """Dừng pipeline hiện tại"""
    global pipeline, loop
    if pipeline:
        pipeline.set_state(Gst.State.NULL)
        pipeline = None
    if loop:
        loop.quit()
        loop = None

def on_message(bus, message, loop):
    """Xử lý message GStreamer"""
    if message.type == Gst.MessageType.EOS:
        print("FINISHED.")
        loop.quit()
    elif message.type == Gst.MessageType.ERROR:
        err, _ = message.parse_error()
        print(f"ERROR: {err}")
        loop.quit()

def set_pipeline_volume(pipeline, volume):
    """Đặt volume cho pipeline, dùng Gst.Iterator đúng cách"""
    if not pipeline:
        return
    it = pipeline.iterate_elements()
    res, elem = it.next()
    while res == Gst.IteratorResult.OK:
        try:
            if elem.get_factory().get_name() == "volume":
                elem.set_property("volume", volume)
                break
        except Exception:
            pass
        res, elem = it.next()


# =====================================================
#  D-Bus Service
# =====================================================
class MusicService(dbus.service.Object):
    DBUS_NAME = "org.example.Music"
    DBUS_PATH = "/org/example/Music"

    def __init__(self, bus):
        super().__init__(bus, self.DBUS_PATH)

    # ------------------- List Songs --------------------
    @dbus.service.method(DBUS_NAME, out_signature="as")
    def ListSongs(self):
        files = [
            f for f in os.listdir(MUSIC_FOLDER)
            if f.lower().endswith(".mp3")
        ]
        return files

    # ------------------- Play Song ---------------------
    @dbus.service.method(DBUS_NAME, in_signature="s")
    def Play(self, song):
        global pipeline, loop, current_volume

        stop_pipeline()

        filepath = os.path.join(MUSIC_FOLDER, song)
        if not os.path.exists(filepath):
            print(f"ERROR: File not found {filepath}")
            return

        print(f"PLAY: {filepath}")

        pipeline_str = (
            f"filesrc location=\"{filepath}\" ! "
            "decodebin ! audioconvert ! audioresample ! "
            f"volume volume={current_volume} ! autoaudiosink"
        )

        pipeline = Gst.parse_launch(pipeline_str)

        def gst_thread():
            global loop
            loop = GLib.MainLoop()

            bus = pipeline.get_bus()
            bus.add_signal_watch()
            bus.connect("message", on_message, loop)

            pipeline.set_state(Gst.State.PLAYING)

            try:
                loop.run()
            except KeyboardInterrupt:
                pass

            pipeline.set_state(Gst.State.NULL)

        t = threading.Thread(target=gst_thread, daemon=True)
        t.start()

    # ------------------- Set Volume --------------------
    @dbus.service.method(DBUS_NAME, in_signature="d")
    def SetVolume(self, value):
        global current_volume, pipeline

        current_volume = float(value)
        set_pipeline_volume(pipeline, current_volume)
        print(f"VOLUME = {current_volume}")
    
    # ------------------- Pause / Resume Playback --------------------
    @dbus.service.method(DBUS_NAME)
    def Pause(self):
        global pipeline
        if not pipeline:
            print("Pause ignored: No active pipeline")
            return

        state = pipeline.get_state(0.1)[1]

        if state == Gst.State.PLAYING:
            pipeline.set_state(Gst.State.PAUSED)
            print(">>> MUSIC PAUSED")
        elif state == Gst.State.PAUSED:
            pipeline.set_state(Gst.State.PLAYING)
            print(">>> MUSIC RESUMED")
        else:
            print(f"Pause ignored: current state = {state}")


# =====================================================
#  MAIN ENTRY
# =====================================================
if __name__ == "__main__":
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

    system_bus = dbus.SystemBus()

    name = dbus.service.BusName(
        MusicService.DBUS_NAME,
        bus=system_bus
    )

    service = MusicService(system_bus)

    print("D-BUS Music Service running...")
    GLib.MainLoop().run()



