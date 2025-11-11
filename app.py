# app fake dữ liệu nhận từ CAN và gửi lên cho QT (view) thông qua socket vì D-Bus đang có chút  lỗi
import socket
import time
import os
import random

# Đường dẫn socket nội bộ
socket_path = "/tmp/uart_socket"

# Xóa socket file cũ nếu tồn tại
try:
    os.remove(socket_path)
except FileNotFoundError:
    pass

# Tạo socket server nội bộ (UNIX domain socket)
server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(socket_path)
server.listen(1)

print("UART Fake Server started, waiting for Qt app to connect...")
conn, _ = server.accept()
print("Qt app connected!")

# Sinh dữ liệu giả như thể đọc từ UART
# Giả lập các gói dữ liệu: TEMP:xx.xx,HUM:yy.yy,COUNT:n
while True:
    temp = round(25 + random.uniform(-2, 2), 2)
    speed = round(0 + random.uniform(0, 320))
    RPM = round(0 + random.uniform(1, 50000))

    line = f"{temp}@{speed}@{RPM}\r\n"
    try:
        conn.sendall(line.encode())
    except BrokenPipeError:
        print("Qt app disconnected. Waiting for reconnect...")
        conn.close()
        conn, _ = server.accept()
        print("Qt app reconnected!")
        continue

    # Tốc độ gửi dữ liệu (20 lần/giây)
    time.sleep(1)

