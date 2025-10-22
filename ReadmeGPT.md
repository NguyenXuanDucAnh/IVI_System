### file readme này được lấy từ file rôt và yêu cầu GPT gen lại cho đẹp

Dưới đây là phiên bản **được chỉnh sửa và trình bày chuẩn Markdown chuyên nghiệp**, dễ đọc, có phân tách rõ phần **thiết lập**, **kiểm tra**, và **kết nối Wi-Fi** khi làm việc với **AGL trên Raspberry Pi 4** 👇

---

# 🚗 AGL IVI System — Hướng Dẫn Cấu Hình Wi-Fi & SSH cho Raspberry Pi 4

---

## 🧩 1. Yêu cầu hệ thống

### 🖥️ Phần cứng

* **Raspberry Pi 4**

  > ⚠️ Không khuyến khích dùng Pi 2 hoặc Pi 3 vì khác biệt lớn về phiên bản **glib**, **Python**, và **driver**, dễ gây lỗi khi build AGL.

### 💽 Phần mềm

* **Host OS:** Ubuntu 22.04 LTS

Cài đặt môi trường build:

```bash
sudo apt-get update
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm vim
```

---

## 🔧 2. Clone source AGL

Clone theo hướng dẫn chính thức của AGL (ví dụ nhánh **quillback**):

📖 Tài liệu:
[https://docs.automotivelinux.org/en/quillback/#01_Getting_Started/02_Building_AGL_Image/08_Building_for_Raspberry_Pi_4/](https://docs.automotivelinux.org/en/quillback/#01_Getting_Started/02_Building_AGL_Image/08_Building_for_Raspberry_Pi_4/)

---

## 🧱 3. Thêm layer custom và ứng dụng `hello-world`

*(Tùy vào mục tiêu của bạn – thêm layer qua `bblayers.conf` và khai báo recipe trong `meta-custom`.)*

---

## 📲 4. Cấu hình Wi-Fi sau khi flash AGL lên Raspberry Pi 4

### 🔹 Kiểm tra driver Wi-Fi

```bash
dmesg | grep wlan
ifconfig -a
```

Ví dụ kết quả thành công:

```
wlan0     Link encap:Ethernet  HWaddr 2C:CF:67:35:A2:71
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
```

> ❌ Nếu **không thấy `wlan0`**, tức là **Wi-Fi chưa được bật hoặc chưa có driver** → cần kiểm tra firmware trong `/lib/firmware/brcm/`.

---

### 🔹 Kiểm tra trạng thái Wi-Fi trong ConnMan

```bash
connmanctl enable wifi
connmanctl technologies
```

Kết quả mong muốn:

```
/net/connman/technology/wifi
  Name = WiFi
  Type = wifi
  Powered = True
  Connected = False
```

> ✅ Nếu có mục `wifi`, nghĩa là **dịch vụ Wi-Fi đã được bật**.
> ❌ Nếu không có, bản image AGL của bạn chưa bật hỗ trợ Wi-Fi (cần thêm `wpa-supplicant` và `connman` khi build).

---

## 📡 5. Kết nối Wi-Fi bằng ConnMan

Bật giao diện tương tác:

```bash
connmanctl
```

Sau đó thực hiện tuần tự các lệnh:

```bash
connmanctl> enable wifi
connmanctl> scan wifi
connmanctl> services
```

Ví dụ kết quả:

```
TP-LINK_2.4GHz_8AE67C wifi_2ccf6735a271_54502d4c494e4b5f322e3447487a5f384145363743_managed_none
Duc-Anh              wifi_2ccf6735a271_4475632d416e68_managed_psk
Kien                 wifi_2ccf6735a271_4b69656e_managed_psk
```

Kích hoạt agent để nhập mật khẩu:

```bash
connmanctl> agent on
```

Kết nối tới mạng Wi-Fi mong muốn:

```bash
connmanctl> connect wifi_2ccf6735a271_4475632d416e68_managed_psk
```

Nhập passphrase khi được hỏi:

```
Passphrase? 0981231344
```

Nếu thành công:

```
[ 1565.501808] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Connected wifi_2ccf6735a271_4475632d416e68_managed_psk
```

Thoát khỏi ConnMan:

```bash
connmanctl> exit
```

---

## 🌐 6. Kiểm tra IP & SSH

Xem thông tin IP:

```bash
ifconfig
```

Ví dụ:

```
wlan0     inet addr:192.168.1.247  Bcast:192.168.1.255  Mask:255.255.255.0
```

> ✅ Raspberry Pi đã có IP → sẵn sàng SSH.

Kết nối SSH từ host:

```bash
ssh root@192.168.1.247
```

---

## 🎯 Kết luận

| Bước                     | Mục tiêu           | Trạng thái mong muốn |
| ------------------------ | ------------------ | -------------------- |
| `connmanctl enable wifi` | Bật module Wi-Fi   | Powered = True       |
| `scan wifi`              | Quét mạng khả dụng | Hiện danh sách SSID  |
| `connect wifi_xxx`       | Kết nối Wi-Fi      | Connected = True     |
| `ifconfig wlan0`         | Kiểm tra IP        | Có địa chỉ IP        |
| `ssh root@<IP>`          | Truy cập hệ thống  | SSH thành công       |

---

> ✅ **Kết nối Wi-Fi thành công!**
> Từ đây, bạn có thể triển khai, debug hoặc gửi file ứng dụng Qt qua SSH trực tiếp.
