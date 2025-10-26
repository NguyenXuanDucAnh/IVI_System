# Không hiển thị màn hình HDMI sau khi boot xong

#### - Mô tả: Khi khởi động (quá trình boot) thì màn hình HDMI có hiển thị nhưng khi khởi động xong thì lại không hiển thị. Cắm debug vẫn dùng bình thường, SSH vẫn ok la thì làm như sau:
##### B1: Trong file cmdline.txt nội dung phải có 2 phần như sau:  console=ttyS0,115200 console=tty1
##### B2: Chạy lệnh fgconsole trong debug. Nếu ra một số nào đó thì nhớ số đó
##### B3: Chạy lệnh chvt <số> với số từ 1-n để xem có chuyển được không. 
###### Minh họa trường hợp đã thành công, như trường hợp này chỉ cần thử "chvt 1" là có thể chạy được:
```
root@raspberrypi4-64:~# fgconsole
7
root@raspberrypi4-64:~# chvt 1
```