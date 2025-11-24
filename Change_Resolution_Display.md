
# CMD kiểm tra xem độ phân giải đang xuất là gì:
```
$ modetest -c
```

Để **thay đổi độ phân giải Raspberry Pi chạy AGL sang 1024×600** (màn hình khác cũng làm tương tự chỉ thay số), bạn cần xem AGL đang xuất hình bằng gì:

* DRM/KMS (thường gặp nhất trên AGL)
* Weston (Wayland compositor)
* X11 (hiếm)

Dưới đây là cách thay đổi theo từng trường hợp.

---

# 🟢 **1. Nếu AGL chạy DRM/KMS (phổ biến trên AGL)**

Bạn có thể ép độ phân giải ngay từ **kernel boot command line**.

## **Bước 1 – Mở file cấu hình boot**

```
sudo nano /boot/config.txt
```

## **Bước 2 – Thêm dòng:**

```
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=87
hdmi_cvt=1024 600 60
```

Giải thích:

| Tham số              | Ý nghĩa                         |
| -------------------- | ------------------------------- |
| hdmi_force_hotplug=1 | Bắt Raspberry Pi luôn xuất HDMI |
| hdmi_group=2         | Chạy chế độ DMT (PC monitor)    |
| hdmi_mode=87         | Cho phép custom resolution      |
| hdmi_cvt             | Đặt width, height, framerate    |

---

## **Bước 3 – Reboot**

```
sudo reboot
```

Sau reboot, kiểm tra lại bằng:

```
cat /sys/class/graphics/fb0/virtual_size
```

---

# 🟡 **2. Nếu AGL chạy Weston (Wayland)**

Bạn có thể ép Weston chọn mode bằng **weston.ini**.

## **Bước 1 – Mở file cấu hình**

Thường nằm ở:

```
/etc/xdg/weston/weston.ini
```

Nếu không có, tạo:

```
sudo nano /etc/xdg/weston/weston.ini
```

## **Bước 2 – Thêm vào:**

```
[output]
name=HDMI-A-1
mode=1024x600
```

> Lưu ý:
> `name=HDMI-A-1` có thể khác tùy thiết bị. Bạn có thể xác nhận bằng:

```
weston-info | grep HDMI
```

## **Bước 3 – Khởi động lại Weston**

```
systemctl restart weston
```

---

# 🔵 **3. Nếu AGL đang chạy X11 (hiếm)**

Dùng:

```
xrandr --output HDMI-1 --mode 1024x600
```

---

# 🔍 **4. Nếu bạn muốn đổi tạm thời trong DRM/KMS mà không cần reboot**

Dùng `modetest`:

## **Liệt kê mode**

```
modetest -M vc4
```

## **Set mode (ví dụ port adalah 33)**

```
modetest -M vc4 -s 33:1024x600
```

> Cách này chỉ tạm thời, reboot là mất.

---

# 🧠 Nếu bạn không biết AGL đang chạy chế độ gì

Chạy:

```
ps aux | grep weston
```

* Có `weston` → đang chạy Wayland
* Không có → khả năng dùng DRM trực tiếp

---
