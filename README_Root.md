# IVI_System

---
# Cau hinh moi truong yeu cau:
## 1. Raspberry pi 4
### - Truong hop khong co pi 4 thi se rat kho build do cac pi2/pi3 su dung cac phien ban glib, python thap va khi build se rat kho khan.
## 2. Ubuntu: 22.04

## 3. Truoc khi build, tien hanh cai dat moi truong build:

```bash
sudo apt-get update
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm vim
```
---
# Tien hanh clone source:
### - Thuc hien clone tu link chinh hang do AGL cung cap: https://docs.automotivelinux.org/en/quillback/#01_Getting_Started/02_Building_AGL_Image/08_Building_for_Raspberry_Pi_4/

---
# Them layer custom va chuong trinh hello-world

--- 
# Cau hinh sau khi flash os cho pi:

---
# Cau hinh wifi va tien hanh SSH:
### Tiến hành cấu hình theo các bước sau:
#### Kiểm tra xem có dịch vụ wifi không:
```
root@raspberrypi4-64:~# dmesg | grep wlan
root@raspberrypi4-64:~# ifconfig -a
can0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
          UP RUNNING NOARP  MTU:72  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

eth0      Link encap:Ethernet  HWaddr 2C:CF:67:35:A2:6F
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:1983 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1983 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:314630 (307.2 KiB)  TX bytes:314630 (307.2 KiB)

wlan0     Link encap:Ethernet  HWaddr 2C:CF:67:35:A2:71
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```
#### trường hợp không thấy wlan0 thì tức là không có dịch vụ wifi. tiến hành kiểm tra theo các bước bên dưới
```
root@raspberrypi4-64:~# connmanctl enable wifi
wifi is already enabled
root@raspberrypi4-64:~#
root@raspberrypi4-64:~# connmanctl technologies
/net/connman/technology/p2p
  Name = P2P
  Type = p2p
  Powered = False
  Connected = False
  Tethering = False
  TetheringFreq = 2412
/net/connman/technology/bluetooth
  Name = Bluetooth
  Type = bluetooth
  Powered = True
  Connected = False
  Tethering = False
  TetheringFreq = 2412
/net/connman/technology/ethernet
  Name = Wired
  Type = ethernet
  Powered = True
  Connected = False
  Tethering = False
  TetheringFreq = 2412
/net/connman/technology/wifi
  Name = WiFi
  Type = wifi
  Powered = True
  Connected = False
  Tethering = False
  TetheringFreq = 2412
```
#### Nếu chạy lệnh technologies mà không có wifi thì là không hỗ trợ wifi hoặc dịch vụ wifi của os không được build
#### Nếu có dịch vụ wifi thì tiến hành theo các bước dưới đây:
```
root@raspberrypi4-64:~# connmanctl
connmanctl> scan wifi
Scan completed for wifi
connmanctl> services
    TP-LINK_2.4GHz_8AE67C wifi_2ccf6735a271_54502d4c494e4b5f322e3447487a5f384145363743_managed_none
    TP-LINK_5GHz_8AE67D  wifi_2ccf6735a271_54502d4c494e4b5f3547487a5f384145363744_managed_none
    Duc-Anh              wifi_2ccf6735a271_4475632d416e68_managed_psk
                         wifi_2ccf6735a271_hidden_managed_psk
    Kien                 wifi_2ccf6735a271_4b69656e_managed_psk
connmanctl> agent on
Agent registered
connmanctl> connect wifi_2ccf6735a271_4475632d416e68_managed_psk
Agent RequestInput wifi_2ccf6735a271_4475632d416e68_managed_psk
  Passphrase = [ Type=psk, Requirement=mandatory, Alternates=[ WPS ] ]
  WPS = [ Type=wpspin, Requirement=alternate ]
Passphrase? 0981231344
connmanctl> [ 1565.501808] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Connected wifi_2ccf6735a271_4475632d416e68_managed_psk
connmanctl> exit
root@raspberrypi4-64:~# ifconfig
can0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
          UP RUNNING NOARP  MTU:72  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

eth0      Link encap:Ethernet  HWaddr 2C:CF:67:35:A2:6F
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:2289 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2289 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:338498 (330.5 KiB)  TX bytes:338498 (330.5 KiB)

wlan0     Link encap:Ethernet  HWaddr 2C:CF:67:35:A2:71
          inet addr:192.168.1.247  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: 2405:4802:4d0:6ce0:2ecf:67ff:fe35:a271/64 Scope:Global
          inet6 addr: 2405:4802:4d0:6ce0::6c8/64 Scope:Global
          inet6 addr: fe80::2ecf:67ff:fe35:a271/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:123 errors:0 dropped:0 overruns:0 frame:0
          TX packets:102 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:25975 (25.3 KiB)  TX bytes:14458 (14.1 KiB)

root@raspberrypi4-64:~#

```
#### Thành công rồi. Tiến hành lấy ip và ssh vào thôi ^^

---
---

# Lỗi Khi SSH
### Mô tả lỗi:
```
$ ssh root@192.168.1.247 
ssh root@192.168.1.247 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY! Someone could be eavesdropping on you right now (man-in-the-middle attack)! It is also possible that a host key has just been changed. The fingerprint for the ED25519 key sent by the remote host is SHA256:x5csAV+Pe6XLaqTySXs7zo+eAk9xQkU2HREojPEWL6E. Please contact your system administrator. Add correct host key in /home/admin1/.ssh/known_hosts to get rid of this message. Offending ECDSA key in /home/admin1/.ssh/known_hosts:3 remove with: ssh-keygen -f "/home/admin1/.ssh/known_hosts" -R "192.168.1.247" Host key for 192.168.1.247 has changed and you have requested strict checking. Host key verification failed.
```
### Nguyên nhân: có thể trước đó máy host đã SSH tới máy target và bây giờ đây host key đã bị thay đổi nên phải gen lại.
### Chạy lệnh sau:
```
$ ssh-keygen -f "/home/admin1/.ssh/known_hosts" -R "192.168.1.247"

```
+ Sau khi chạy xong, tiến hành SSH lại vào target!