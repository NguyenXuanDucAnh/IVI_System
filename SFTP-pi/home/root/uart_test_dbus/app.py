
#!/usr/bin/env python3
import time
import serial
import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib

# ----------------------------
# UART CONFIG
# ----------------------------
ser = serial.Serial('/dev/ttyACM0', 115200, timeout=1)

# ----------------------------
# D-Bus Service Implementation
# ----------------------------

BUS_NAME = "org.example.Vehicle"
OBJ_PATH = "/org/example/Vehicle"
IFACE = "org.example.Vehicle"

class VehicleService(dbus.service.Object):
    def __init__(self, bus):
        super().__init__(bus, OBJ_PATH)
        self.speed = 0
        self.rpm = 0
        self.temp = 0
        self.xinhan = 0
        self.seatbelt = 0

    # @dbus.service.method(IFACE, in_signature="", out_signature="s")
    # def GetData(self):
    #     return f"{self.temp}@{self.speed}@{self.rpm}@"

    @dbus.service.signal(IFACE, signature="s")
    def DataUpdated(self, value):
        pass

    def update_and_emit(self):
        value = f"{self.temp}@{self.speed}@{self.rpm}@{self.xinhan}@{self.seatbelt}@"
        self.DataUpdated(value)


    # # service gửi dữ liệu từ máy tính xuống vi điều khiển qua UART
    # @dbus.service.method(IFACE, in_signature="s", out_signature="b")
    # def SendUART(self, message):
    #     """
    #     Gửi 1 chuỗi qua UART
    #     """

    #     print("Start Print UART")
    #     try:
    #         if isinstance(message, str):
    #             message_bytes = message.encode('utf-8')
    #         else:
    #             message_bytes = bytes(message)

    #         ser.write(message_bytes)
    #         ser.flush()
    #         print("UART TX:", message_bytes)
    #         return True

    #     except Exception as e:
    #         print("UART TX Error:", e)
    #         return False



# ----------------------------
# MAIN CODE
# ----------------------------

dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
bus = dbus.SessionBus()
# bus = dbus.SystemBus()
name = dbus.service.BusName(BUS_NAME, bus)

vehicle = VehicleService(bus)

print("Vehicle D-Bus Service started.")

buffer = bytearray()

print("Reading UART...")

# message_test = "Ducanhdeptrainhatthegioi"
# message_bytes = message_test.encode('utf-8')
# ser.write(message_bytes)
# ser.flush()

while True:
    byte = ser.read(1)
    if not byte:
        continue

    buffer += byte

    # time.sleep (2)

    if buffer.endswith(b"###\n"):
        
        # print (buffer)

        start = buffer.find(b"###")
        if start >= 0 and len(buffer) >= start + 8:
            try:
                ID = buffer[start + 3]
                bit_high = buffer[start + 4]
                bit_low = buffer[start + 5]

                value = (bit_high << 8) | bit_low

                if ID == 0x01: # ID của bản tin dữ liệu tốc độ
                    vehicle.speed = value
                elif ID == 0x02: # ID của bản tin RPM
                    vehicle.rpm = value
                elif ID == 0x03: # ID của bản tin Nhiệt độ dầu động cơ
                    vehicle.temp = value
                elif ID == 0x04: # ID của bản tin Đèn Xinhan
                    vehicle.xinhan = value
                elif ID == 0x05: # ID của bản tin SeatBelt
                    vehicle.seatbelt = value


                vehicle.update_and_emit()

            except Exception as e:
                print("Error parsing frame:", e)

        buffer = bytearray()
    
