
# #!/usr/bin/env python3
# import socket
# import json
# import time
# from datetime import datetime, timezone, timedelta


# GPSD_HOST = "127.0.0.1"
# GPSD_PORT = 2947

# def main():
#     s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     s.connect((GPSD_HOST, GPSD_PORT))

#     # Enable JSON streaming
#     s.sendall(b'?WATCH={"enable":true,"json":true}\n')

#     print("Connected to gpsd\n")

#     while True:
#         print ("code is running")

#         data = s.recv(4096).decode(errors="ignore")
#         for line in data.split("\n"):
#             if not line.strip():
#                 continue

#             try:
#                 msg = json.loads(line)
#             except json.JSONDecodeError:
#                 continue

#             if msg.get("class") == "TPV":
#                 lat = msg.get("lat")
#                 lon = msg.get("lon")
#                 time = msg.get("time")
#                 mode = msg.get("mode", 0)

#                 if mode >= 2:
#                     print(f"Time : {time}")
#                     print(f"Lat  : {lat}")
#                     print(f"Lon  : {lon}")
#                     print("-" * 40)

# if __name__ == "__main__":
#     main()


# Sửa lại code:

import time
import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib

BUS_NAME = "org.example.MapsOffline"
IFACE = BUS_NAME
OBJ_PATH = "/org/example/MapsOffline"
DBUS_NAME = "org.example.MapsOffline"  # Thêm dòng này

class MapsOfflineService(dbus.service.Object):
    def __init__(self, bus):
        super().__init__(bus, OBJ_PATH)
        self.index = 0  # Đổi từ global sang instance variable
        self.list_lat_lon = [
            "21.01184472232485,105.66169958108217",
            "21.01201498464116,105.66172103875454",
            "21.01225535463924,105.66179614060778",
            "21.012665985823222,105.66179614060778",
            "21.013006508386674,105.66186051362483",
            "21.01309664658217,105.66194634431425",
            "21.01363747461123,105.66206436151222",
            "21.013812742533275,105.66209118360267",
            "21.013937933780042,105.6620697259303",
            "21.01415827011916,105.66206436151222",
            "21.01424339998119,105.6620750903484",
            "21.014443705347222,105.6620697259303",
            "21.014794239090502,105.66214482778356",
            "21.01521487849495,105.66217701429207",
            "21.015430205350032,105.66218237871017"
        ]

            
    
    # @dbus.service.method(DBUS_NAME, out_signature="s")  # Sửa: thêm out_signature
    @dbus.service.signal(IFACE, signature="s")
    def DataMapUpdated(self, value):
        pass


    def GetLatLon(self):
        result = self.list_lat_lon[self.index]
        self.index += 1
        if self.index >= len(self.list_lat_lon):
            self.index = 0
        self.DataMapUpdated(result)

if __name__ == "__main__":
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SessionBus()
    name = dbus.service.BusName(BUS_NAME, bus=bus)
    service_map = MapsOfflineService(bus)
    print("D-Bus MapsOffline Service running...")
    # GLib.MainLoop().run()
    while True:
        service_map.GetLatLon()
        time.sleep(0.1)