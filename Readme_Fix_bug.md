
# **I. Không hiển thị màn hình HDMI sau khi boot xong**

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
---
---
# **II. Khi chạy lệnh configure sinh ra lỗi sau:**
## 1. Lỗi: ***aarch64-agl-linux-g++: error: unrecognized command-line option '-mfloat-abi=softfp'***
### + Hướng giải quyết: vào file device (thường nằm ở đường dẫn: /qtbase/mkspecs/device) và chọn đúng cái device mà đang chỉ định khi chạy lệnh configure. Sau đó sửa file qmake.conf như sau:
-> Sửa include(../common/linux_arm_device_post.conf) thành include(../common/linux_device_post.conf)
Giải thích: Do đang build cho Pi4 với aarch64 nhưng linux_arm_device_post lại là option cho 32 bit nên sẽ lỗi.

### 2. Lỗi:
```
 aarch64-agl-linux-g++: error: unrecognized command-line option '-mfpu=crypto-neon-fp-armv8' 
 aarch64-agl-linux-g++: error: unrecognized command-line option '-mfloat-abi=hard'
 ```
### + Hướng giải quyết: Vẫn vào file qmake.conf giống cách 1.
-> Sửa:
```
🔹 Bước 1: Tạo mkspec mới
        cd qtbase/mkspecs/devices
        cp -r linux-rasp-pi4-v3d-g++ linux-rasp-pi4-agl64-g++

🔹 Bước 2: Sửa file qmake.conf

        Mở file:
            qtbase/mkspecs/devices/linux-rasp-pi4-agl64-g++/qmake.conf
        Xóa (hoặc comment) dòng:
            QMAKE_CFLAGS    += -march=armv8-a -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard
        Thay bằng:
            QMAKE_CFLAGS    += -march=armv8-a
            QMAKE_CXXFLAGS  += -march=armv8-a
        Và kiểm tra dòng chỉ định compiler(nếu không có thì tự thêm vào):
            QMAKE_CC = aarch64-agl-linux-gcc
            QMAKE_CXX = aarch64-agl-linux-g++
            QMAKE_LINK = aarch64-agl-linux-g++
            QMAKE_AR = aarch64-agl-linux-ar cqs

🔹 Bước 3: Chạy lại configure với mkspec mới với -device là linux-rasp-pi4-agl64-g++ (bởi vì trước đó rất có thể đang chạy với -devcice là linux-rasp-pi4-v3d-g++ hoặc một device cho pi4 khác. )
```
## * Bonus: lệnh configure mẫu (trong trường hợp chạy lần đầu thì chạy -device là linux-rasp-pi4-v3d-g++ vì rất có thể khi đó linux-rasp-pi4-agl64-g++ chưa được tạo. Nếu cần tạo thì xem phần lỗi 2 của mục II bên trên)
```
./configure -release -opengl es2 -eglfs -device linux-rasp-pi4-agl64-g++ -device-option CROSS_COMPILE=${CROSS_COMPILE} -sysroot ${SDKTARGETSYSROOT} -prefix $PWD/qtbase -opensource -confirm-license -nomake tests -nomake examples -skip qtwebengine -skip qtwayland -skip qtwebengine -v

lệnh update:
../qt-everywhere-src-5.15.2/configure     -release -opengl es2 -eglfs     -device linux-rasp-pi4-v3d-g++     -device-option CROSS_COMPILE=/opt/agl-sdk/17.1.12-aarch64/sysroots/x86_64-aglsdk-linux/usr/bin/aarch64-agl-linux/aarch64-agl-linux-     -sysroot $SDKTARGETSYSROOT     -prefix /usr/local/qt5.15     -extprefix ~/opt/agl-sdk/17.1.12-aarch64/qt5.15     -opensource -confirm-license     -skip qtscript -skip qtwayland -skip qtwebengine     -nomake tests -make libs     -pkg-config -no-use-gold-linker -v -recheck     -L${SDKTARGETSYSROOT}/usr/lib/aarch64-agl-linux     -I${SDKTARGETSYSROOT}/usr/include/aarch64-agl-linux     -qpa eglfs -no-feature-eglfs_brcm


```
---
---
# III. Fix lỗi khi make QT (sau khi đã configure thành công ở phần II)
### 1. Lỗi Perl:
```
perl /home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/src/corelib/mimetypes/mime/generate.pl --zstd mimetypes/mime/packages/freedesktop.org.xml > .rcc/qmimeprovider_database.cpp perl: warning: Setting locale failed. perl: warning: Please check that your locale settings: LANGUAGE = (unset), LC_ALL = (unset), LC_ADDRESS = "vi_VN", LC_NAME = "vi_VN", LC_MONETARY = "vi_VN", LC_PAPER = "vi_VN", LC_IDENTIFICATION = "vi_VN", LC_TELEPHONE = "vi_VN", LC_MEASUREMENT = "vi_VN", LC_TIME = "vi_VN", LC_NUMERIC = "vi_VN", LANG = "en_US.UTF-8" are supported and installed on your system. perl: warning: Falling back to a fallback locale ("en_US.UTF-8"). Can't locate File/Spec/Functions.pm in @INC (you may need to install the File::Spec::Functions module) (@INC contains: /media/admin1/SSD-480GB/AGL2204/AGL/quillback/raspberrypi4/tmp/deploy/sdk/agl-sdk/sysroots/x86_64-aglsdk-linux/usr/bin/../..//usr/lib/perl5/site_perl/5.34.3/x86_64-linux /media/admin1/SSD-480GB/AGL2204/AGL/quillback/raspberrypi4/tmp/deploy/sdk/agl-sdk/sysroots/x86_64-aglsdk-linux/usr/bin/../..//usr/lib/perl5/site_perl/5.34.3 /media/admin1/SSD-480GB/AGL2204/AGL/quillback/raspberrypi4/tmp/deploy/sdk/agl-sdk/sysroots/x86_64-aglsdk-linux/usr/bin/../..//usr/lib/perl5/vendor_perl/5.34.3 /media/admin1/SSD-480GB/AGL2204/AGL/quillback/raspberrypi4/tmp/deploy/sdk/agl-sdk/sysroots/x86_64-aglsdk-linux/usr/bin/../..//usr/lib/perl5/5.34.3/x86_64-linux /media/admin1/SSD-480GB/AGL2204/AGL/quillback/raspberrypi4/tmp/deploy/sdk/agl-sdk/sysroots/x86_64-aglsdk-linux/usr/bin/../..//usr/lib/perl5/5.34.3 /usr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64-aglsdk-linux/usr/lib/perl5/site_perl/5.34.3/x86_64-linux /usr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64-aglsdk-linux/usr/lib/perl5/site_perl/5.34.3 /usr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64-aglsdk-linux/usr/lib/perl5/vendor_perl/5.34.3/x86_64-linux /usr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64-aglsdk-linux/usr/lib/perl5/vendor_perl/5.34.3 /usr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64-aglsdk-linux/usr/lib/perl5/5.34.3/x86_64-linux /usr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64-aglsdk-linux/usr/lib/perl5/5.34.3) at /home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/src/corelib/mimetypes/mime/generate.pl line 35. BEGIN failed--compilation aborted at /home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/src/corelib/mimetypes/mime/generate.pl line 35. make[3]: *** [Makefile:1985: .rcc/qmimeprovider_database.cpp] Error 2 make[3]: *** Waiting for unfinished jobs.... g++ -Wl,-O1 -Wl,--gc-sections -o ../../../bin/qdbuscpp2xml .obj/moc.o .obj/preprocessor.o .obj/generator.o .obj/parser.o .obj/token.o .obj/collectjson.o .obj/qdbuscpp2xml.o /home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/lib/libQt5BootstrapDBus.a /home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/lib/libQt5Bootstrap.a -lpthread make[3]: Leaving directory '/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/src/tools/qdbuscpp2xml' make[3]: Leaving directory '/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/src/corelib' make[2]: *** [Makefile:226: sub-corelib-make_first] Error 2 make[2]: Leaving directory '/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/src' make[1]: *** [Makefile:51: sub-src-make_first] Error 2 make[1]: Leaving directory '/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase' make: *** [Makefile:86: module-qtbase-make_first] Error 2
```
#### - Nguyên nhân và khắc phục:
    + Lỗi này chính xác là như sau: 
    ```
    Can't locate File/Spec/Functions.pm in @INC (you may need to install the File::Spec::Functions module)
    ```
    + Nguyên nhân: 
    ```
    Qt trong giai đoạn build qtbase cần Perl để tạo file MIME database (generate.pl), nhưng môi trường SDK của AGL thiếu module Perl cơ bản.

    Đặc biệt, khi cross compile Qt bằng SDK của AGL, make sử dụng perl của SDK (không phải hệ thống host), và SDK này rất tối giản → thiếu các thư viện Perl tiêu chuẩn.

    ==> Cách khắc phục: Dùng Perl của hệ thống host thay vì Perl trong SDK. Tức là bạn ép Qt build script dùng perl hệ thống của Ubuntu, vốn đầy đủ module.

    🔧 Cách làm:

        Trước khi make, chạy: export PATH=/usr/bin:$PATH
        Sau đó gõ: which perl
            Nó phải trả về /usr/bin/perl (không phải perl trong SDK).
        Rồi chạy lại:
            make -j$(nproc)
    ```
### 2. Lỗi: numeric_limits
```
In file included from qqmlprofilerevent.cpp:40: qqmlprofilerevent_p.h: In member function 'void QQmlProfilerEvent::assignNumbers(const Container&)': qqmlprofilerevent_p.h:314:65: error: 'numeric_limits' is not a member of 'std' 314 | static_cast<quint16>(numbers.size()) : std::numeric_limits<quint16>::max(); | ^~~~~~~~~~~~~~ qqmlprofilerevent_p.h:314:87: error: expected primary-expression before '>' token 314 | static_cast<quint16>(numbers.size()) : std::numeric_limits<quint16>::max(); | ^ qqmlprofilerevent_p.h:314:90: error: '::max' has not been declared; did you mean 'std::max'? 314 | static_cast<quint16>(numbers.size()) : std::numeric_limits<quint16>::max(); | ^~~ | std::max In file included from /media/admin1/SSD-480GB/AGL2204/AGL/quillback/raspberrypi4/tmp/deploy/sdk/agl-sdk/sysroots/aarch64-agl-linux/usr/include/c++/11.5.0/algorithm:62, from /home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/include/QtCore/../../src/corelib/global/qglobal.h:142, from /home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/include/QtCore/qglobal.h:1, from qqmlprofilerclientdefinitions_p.h:54, from qqmlprofilerevent_p.h:43, from qqmlprofilerevent.cpp:40: /media/admin1/SSD-480GB/AGL2204/AGL/quillback/raspberrypi4/tmp/deploy/sdk/agl-sdk/sysroots/aarch64-agl-linux/usr/include/c++/11.5.0/bits/stl_algo.h:3467:5: note: 'std::max' declared here 3467 | max(initializer_list<_Tp> __l, _Compare __comp) | ^~~ aarch64-agl-linux-g++ -c -pipe -march=armv8-a --sysroot=/media/admin1/SSD-480GB/AGL2204/AGL/quillback/raspberrypi4/tmp/deploy/sdk/agl-sdk/sysroots/aarch64-agl-linux -O2 -fPIC -std=c++1z -fvisibility=hidden -fvisibility-inlines-hidden -fno-exceptions -Wall -Wextra -Wvla -Wdate-time -Wshift-overflow=2 -Wduplicated-cond -Wno-stringop-overflow -Wno-format-overflow -D_REENTRANT -DQT_NO_LINKED_LIST -DQT_NO_LINKED_LIST -DQT_NO_JAVA_STYLE_ITERATORS -DQT_NO_NARROWING_CONVERSIONS_IN_CONNECT -DQT_BUILD_QMLDEBUG_LIB -DQT_BUILDING_QT -DQT_NO_CAST_TO_ASCII -DQT_ASCII_CAST_WARNINGS -DQT_MOC_COMPAT -DQT_USE_QSTRINGBUILDER -DQT_DEPRECATED_WARNINGS -DQT_DISABLE_DEPRECATED_BEFORE=0x050000 -DQT_DEPRECATED_WARNINGS_SINCE=0x060000 -DQT_NO_EXCEPTIONS -D_LARGEFILE64_SOURCE -D_LARGEFILE_SOURCE -DQT_NO_DEBUG -DQT_PACKETPROTOCOL_LIB -DQT_QML_LIB -DQT_NETWORK_LIB -DQT_CORE_LIB -I. -I../../include -I../../include/QtQmlDebug -I../../include/QtQmlDebug/5.15.0 -I../../include/QtQmlDebug/5.15.0/QtQmlDebug -I../../include/QtQml/5.15.0 -I../../include/QtQml/5.15.0/QtQml -I../../include/QtPacketProtocol -I../../include/QtPacketProtocol/5.15.0 -I../../include/QtPacketProtocol/5.15.0/QtPacketProtocol -I/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/include/QtCore/5.15.0 -I/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/include/QtCore/5.15.0/QtCore -I../../include/QtQml -I/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/include -I/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/include/QtNetwork -I/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/include/QtCore -I.moc -I/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/mkspecs/devices/linux-rasp-pi4-agl64-g++ -o .obj/qqmlprofilereventtype.o qqmlprofilereventtype.cpp make[3]: *** [Makefile:3981: .obj/qqmlprofilerevent.o] Error 1 make[3]: *** Waiting for unfinished jobs.... make[3]: Leaving directory '/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtdeclarative/src/qmldebug' make[2]: *** [Makefile:575: sub-qmldebug-make_first-ordered] Error 2 make[2]: Leaving directory '/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtdeclarative/src' make[1]: *** [Makefile:50: sub-src-make_first] Error 2 make[1]: Leaving directory '/home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtdeclarative' make: *** [Makefile:338: module-qtdeclarative-make_first] Error 2
```
#### Nguyên nhân và khắc phục:
```
error: 'numeric_limits' is not a member of 'std'
```
```
+) File gây lỗi là:

qtdeclarative/src/qmldebug/qqmlprofilerevent_p.h


+) Trong đó có đoạn: std::numeric_limits<quint16>::max();
    Nhưng file này thiếu include <limits>, nên trình biên dịch không biết std::numeric_limits.
    Trên các GCC cũ (như 8.x/9.x), Qt vẫn build được vì <limits> được include gián tiếp qua <algorithm>  nhưng GCC 11 trở lên tách tường minh, nên lỗi này xuất hiện.

+) Bạn chỉ cần thêm dòng: #include <limits>
    vào đầu file sau: qtdeclarative/src/qmldebug/qqmlprofilerevent_p.h

Cụ thể:
    #include "qqmlprofilerclientdefinitions_p.h"
    #include <QtCore/qvector.h>
    #include <QtCore/qstring.h>
    #include <limits>    // <-- thêm dòng này

+) Sau đó, build lại:
    make -j$(nproc)
```