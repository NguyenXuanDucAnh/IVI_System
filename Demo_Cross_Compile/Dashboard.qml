import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15


Item {
    visible: true
    width: 1024
    height: 600
    anchors.fill: parent

    // --- Background Image ---
    Image {
        id: background
        source: "assert/Dash_board/Back_ground.png"
        anchors.fill: parent
        fillMode: Image.Stretch  // hoặc .Stretch nếu muốn kéo giãn đầy đủ
    }

    // Load font từ file, không có cái này thì không hiện text lên được
    FontLoader {
        id: unitext_regular_font
        source: "Fonts/Orbitron-VariableFont_wght.ttf"   // đường dẫn tới font Orbitron
    }

    FontLoader {
        id:lato_regular_font
        source: "Fonts/Lato-Regular.ttf"   // đường dẫn tới font Lato
    }

    // Text sử dụng font vừa load
    // --- Text tự co dãn theo ảnh ---

    Item {
        id: temperatureOilItem
        // toạ độ gốc trong ảnh thật
        property real baseX: 240
        property real baseY: 60
        property real baseWidth: 65      // bạn có thể chỉnh kích thước vùng hiển thị
        property real baseHeight: 20

        // Tỉ lệ co giãn theo kích thước ảnh nền
        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Để dễ debug, bạn có thể bật màu nền nhẹ
//         Rectangle { anchors.fill: parent; color: "#40ffffff" }

        Text {
            id: label_temperature_oil
            anchors.centerIn: parent        // ✅ canh giữa trong Item
            font.family: unitext_regular_font.name
            font.pixelSize: 16 * (background.width / background.sourceSize.width)
            color: "white"
            text: uartProvider.Temperature_oil_info
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Item {
        id: rpmItem
        // toạ độ gốc trong ảnh thật
        property real baseX: 46
        property real baseY: 60
        property real baseWidth: 57      // bạn có thể chỉnh kích thước vùng hiển thị
        property real baseHeight: 20

        // Tỉ lệ co giãn theo kích thước ảnh nền
        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Để dễ debug, bạn có thể bật màu nền nhẹ
//         Rectangle { anchors.fill: parent; color: "#40ffffff" }

        Text {
            id: label_rpm
            anchors.centerIn: parent        // ✅ canh giữa trong Item
            font.family: unitext_regular_font.name
            font.pixelSize: 16 * (background.width / background.sourceSize.width)
            color: "white"
            text: uartProvider.rpm_info
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Item {
        id: speedItem
        // toạ độ gốc trong ảnh thật
        property real baseX: 124
        property real baseY: 47
        property real baseWidth: 100      // bạn có thể chỉnh kích thước vùng hiển thị
        property real baseHeight: 60

        // Tỉ lệ co giãn theo kích thước ảnh nền
        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Để dễ debug, bạn có thể bật màu nền nhẹ
//         Rectangle { anchors.fill: parent; color: "#40ffffff" }

        Text {
            id: label_speed
            anchors.centerIn: parent        // ✅ canh giữa trong Item
            font.family: unitext_regular_font.name
            font.pixelSize: 48 * (background.width / background.sourceSize.width)
            color: "white"
            text: uartProvider.speed_info
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    // label thời gian
    Item {
        id: timeItem
        // toạ độ gốc trong ảnh thật
        property real baseX: 931
        property real baseY: 6
        property real baseWidth: 83      // bạn có thể chỉnh kích thước vùng hiển thị
        property real baseHeight: 38

        // Tỉ lệ co giãn theo kích thước ảnh nền
        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Để dễ debug, bạn có thể bật màu nền nhẹ
//         Rectangle { anchors.fill: parent; color: "#40ffffff" }

        Text {
            id: label_time
            anchors.centerIn: parent        // ✅ canh giữa trong Item
            font.family: lato_regular_font.name
            font.pixelSize: 32 * (background.width / background.sourceSize.width)
            color: "white"
            text: "15:30"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    // -- thêm icon Home app => đưa về màn hình dashboard
    Item {
        id: homeApp
        property alias iconSource: iconHomeApp.source   // cho phép set icon từ ngoài
        property real baseX: 11
        property real baseY: 518
        property real baseWidth: 77
        property real baseHeight: 75

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconHomeApp
            anchors.centerIn: parent
            source: "assert/App Home Icon.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                console.log("Icon button clicked!")
                // thực hiện hành động bạn muốn
            }
        }

    }
    // -- thêm icon Mapp app
    Item {
        id: mapApp
        property alias iconSource: iconMapApp.source   // cho phép set icon từ ngoài
        property real baseX: 113
        property real baseY: 521
        property real baseWidth: 77
        property real baseHeight: 75

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconMapApp
            anchors.centerIn: parent
            source: "assert/App Map Icon.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                console.log("Icon button clicked!")
                // thực hiện hành động bạn muốn
                stackView.push ('Googlemap.qml')
            }
        }
    }
    // -- thêm icon bluetooth app
    Image {
        id: bleEnableIcon
        property alias iconSource: iconBluetoothApp.source   // cho phép set icon từ ngoài
        property real baseX: 888
        property real baseY: 3
        property real baseWidth: 45
        property real baseHeight: 45

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: bleEnableIconImage
            anchors.centerIn: parent
            source: "assert/bleEnableIcon.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
            opacity: 1.0 // mặc định là tắt bluetooth nên không hiển thị lên màn hình
        }
    }
    Item {
        id: bluetoothApp
        property alias iconSource: iconBluetoothApp.source   // cho phép set icon từ ngoài
        property real baseX: 215
        property real baseY: 521
        property real baseWidth: 80
        property real baseHeight: 80

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconBluetoothApp
            anchors.centerIn: parent
            source: "assert/App bluetooth icon.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                console.log("Icon button clicked!")
                // thực hiện hành động bạn muốn
                bleEnableIcon.opacity = 1.0 - bleEnableIcon.opacity
            }
        }
    }

    // -- thêm icon Spotify app
    Item {
        id: spotifyApp
        property alias iconSource: iconSpotifyApp.source   // cho phép set icon từ ngoài
        property real baseX: 323
        property real baseY: 521
        property real baseWidth: 80
        property real baseHeight: 80

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconSpotifyApp
            anchors.centerIn: parent
            source: "assert/App spotify icon.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                console.log("Icon spotify button clicked!")
                // thực hiện hành động bạn muốn
                stackView.push ("Music.qml")
            }
        }
    }

    // -- thêm icon radio app
    Item {
        id: radioApp
        property alias iconSource: iconRadioapp.source   // cho phép set icon từ ngoài
        property real baseX: 642
        property real baseY: 521
        property real baseWidth: 80
        property real baseHeight: 80

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconRadioapp
            anchors.centerIn: parent
            source: "assert/App Radio Icon.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                console.log("Icon radio button clicked!")
                // thực hiện hành động bạn muốn
                stackView.push ("radio.qml")
            }
        }
    }

    // -- thêm icon Phone app
    Item {
        id: phoneApp
        property alias iconSource: iconPhoneApp.source   // cho phép set icon từ ngoài
        property real baseX: 743
        property real baseY: 521
        property real baseWidth: 80
        property real baseHeight: 80

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconPhoneApp
            anchors.centerIn: parent
            source: "assert/App phone icon.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                console.log("Icon phone button clicked!")
                // thực hiện hành động bạn muốn
                stackView.push ("phone.qml")
            }
        }
    }

    // -- thêm icon A/C app
    Item {
        id: acApp
        property alias iconSource: iconACApp.source   // cho phép set icon từ ngoài
        property real baseX: 842
        property real baseY: 519
        property real baseWidth: 80
        property real baseHeight: 80

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconACApp
            anchors.centerIn: parent
            source: "assert/App seat-warmer icon.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                console.log("Icon AC button clicked!")
                // thực hiện hành động bạn muốn
                stackView.push ("spotify.qml")
            }
        }
    }

    // -- thêm icon Setting app
    Item {
        id: settingApp
        property alias iconSource: iconSettingApp.source   // cho phép set icon từ ngoài
        property real baseX: 926
        property real baseY: 519
        property real baseWidth: 80
        property real baseHeight: 80

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconSettingApp
            anchors.centerIn: parent
            source: "assert/App Setting Icon.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                console.log("Icon setting button clicked!")
                // thực hiện hành động bạn muốn
                stackView.push ("spotify.qml")
            }
        }
    }

    // hiển thị bài hát hiện tại
    Item {
        id: nameCurrentSongPannel
        property real baseX: 365
        property real baseY: 397
        property real baseWidth: 427
        property real baseHeight: 26

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        Text {
            id: curent_song
            anchors.centerIn: parent        // ✅ canh giữa trong Item
            font.family: lato_regular_font.name
            font.pixelSize: 16 * (background.width / background.sourceSize.width)
            color: "white"
//            text: mp3Ctrl.currentSong // lấy tên bài hát hiện tại
            text: bleCtrl.currentAudio
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    // thêm nút play/pause music
    Item {
        id: playMusic
        property alias iconSource: iconPlayMusic.source   // cho phép set icon từ ngoài
        property real baseX: 565
        property real baseY: 442
        property real baseWidth: 23
        property real baseHeight: 31
        property bool active: false   // trạng thái icon

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconPlayMusic
            anchors.centerIn: parent
            source: playMusic.active?
                      "assert/Music_Tab/Play Music.png":
                      "assert/Music_Tab/Pause Music.png"
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn
                // mp3Ctrl.playPause()
                playMusic.active = !playMusic.active
                bleCtrl.TogglePlayPause()
            }
        }
    }

    // thêm nút next music
    Item {
        id: nextMusic
        property alias iconSource: iconNextMusic.source   // cho phép set icon từ ngoài
        property real baseX: 631
        property real baseY: 441
        property real baseWidth: 23
        property real baseHeight: 31

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconNextMusic
            anchors.centerIn: parent
            source: "assert/Music_Tab/Next Music.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn
                // mp3Ctrl.next()
                bleCtrl.NextTrack()
            }
        }
    }


    // thêm nút previous music
    Item {
        id: previousMusic
        property alias iconSource: iconPreviousMusic.source   // cho phép set icon từ ngoài
        property real baseX: 486
        property real baseY: 441
        property real baseWidth: 23
        property real baseHeight: 31

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconPreviousMusic
            anchors.centerIn: parent
            source: "assert/Music_Tab/Last Music.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn
                // mp3Ctrl.previous()
                bleCtrl.PreviousTrack()
            }
        }
    }

    // thêm phần điều chỉnh volume âm nhạc
    Slider {
        id: volumeSlider
        property real baseX: 840
        property real baseY: 52
        property real baseWidth: 140
        property real baseHeight: 20

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        from: 0
        value: 10.0
        to: 10
        // onValueChanged: mp3Ctrl.setVolume(value)
        onValueChanged: bleCtrl.SetVolume(value)

    }

    // thêm Icon/nút tăng âm lượng
    Item {
        id: increaseVolume
        property alias iconSource: iconIncreaseVolume.source   // cho phép set icon từ ngoài
        property real baseX: 980
        property real baseY: 50
        property real baseWidth: 30
        property real baseHeight: 30

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconIncreaseVolume
            anchors.centerIn: parent
            source: "assert/Music_Tab/Increase volume.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn
                volumeSlider.value = volumeSlider.value + 1
            }
        }
    }
    // thêm Icon/nút giảm âm lượng
    Item {
        id: decreaseVolume
        property alias iconSource: iconDecreaseVolume.source   // cho phép set icon từ ngoài
        property real baseX: 813
        property real baseY: 50
        property real baseWidth: 30
        property real baseHeight: 30

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconDecreaseVolume
            anchors.centerIn: parent
            source: "assert/Music_Tab/Decrease volume.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn
                volumeSlider.value = volumeSlider.value - 1
            }
        }
    }

    // Thêm icon rẽ xinhan trái
    Item {
        id: turnleftArrow
        property alias iconSource: iconturnleftArrow.source   // cho phép set icon từ ngoài
        property real baseX: 43
        property real baseY: 6
        property real baseWidth: 39
        property real baseHeight: 47

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Cập nhật trạng thái xinhan liên tục
        Timer {
            id: xinhanleftPoll
            interval: 1000      // 1000ms quét một lần (tùy chỉnh)
            running: true
            repeat: true
            onTriggered: {
                var sig = uartProvider.xinhan_info     // lấy dữ liệu xinhan

                if (sig === 0x00) {
//                    iconturnleftArrow.visible = false
                    blinkleftTimer.running = false
                    iconturnleftArrow.opacity = 0.3
                }
                else if (sig === 0x01 || sig === 0x03) {
//                    iconturnleftArrow.visible = true
                    blinkleftTimer.running = true
                }
            }
        }

        // Timer để nhấp nháy icon 1s
        Timer {
            id: blinkleftTimer
            interval: 200    // 500ms → on/off → chu kỳ 1s
            repeat: true
            running: false
            onTriggered: {
                iconturnleftArrow.opacity = (iconturnleftArrow.opacity < 1) ? 1 : 0.3
            }
        }

        // Icon
        Image {
            id: iconturnleftArrow
            anchors.centerIn: parent
            source: "/assert/Dash_board/Shift Left Icon.png"
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
//            visible: false   // mặc định tắt
            opacity: 0.3
        }
    }
    // Thêm icon rẽ xinhan phải
    Item {
        id: turnrightArrow
        property alias iconSource: iconturnrightArrow.source
        property real baseX: 233
        property real baseY: 6
        property real baseWidth: 39
        property real baseHeight: 47

        // vị trí & kích thước theo background
        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Cập nhật trạng thái xinhan liên tục
        Timer {
            id: xinhanrightPoll
            interval: 1000      // 1s quét một lần (tùy chỉnh)
            running: true
            repeat: true
            onTriggered: {
                var sig = uartProvider.xinhan_info     // lấy dữ liệu xinhan

                if (sig === 0x00) {
                    blinkrightTimer.running = false
                    iconturnrightArrow.opacity = 0.3
                }
                else if (sig === 0x02 || sig === 0x03) { // 0x03 => nháy đèn hazard
                    blinkrightTimer.running = true
                }
            }
        }

        // Timer để nhấp nháy icon 1s
        Timer {
            id: blinkrightTimer
            interval: 200    // 500ms → on/off → chu kỳ 1s
            repeat: true
            running: false
            onTriggered: {

                iconturnrightArrow.opacity = (iconturnrightArrow.opacity < 1) ? 1 : 0.3
            }
        }

        // Icon
        Image {
            id: iconturnrightArrow
            anchors.centerIn: parent
            source: "/assert/Dash_board/Shift Right Icon.png"
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
//            visible: false   // mặc định tắt
            opacity: 0.3
        }
    }

    // Thêm icon cảnh báo đeo dây an toàn
    Item {
        id: seatbeltWarning
        property alias iconSource: iconseatbeltWarning.source   // cho phép set icon từ ngoài
        property real baseX: 167
        property real baseY: 1
        property real baseWidth: 50
        property real baseHeight: 50

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Cập nhật trạng thái xinhan liên tục
        Timer {
            id: seatbeltWarningPoll
            interval: 500      // 1s quét một lần (tùy chỉnh)
            running: true
            repeat: true
            onTriggered: {
                var sig = uartProvider.seatbelt_warning     // lấy dữ liệu seatbelt

                if (sig === 0x00) {
//                    iconseatbeltWarning.visible = false
                    seatbeltWarningTimer.running = false
                    iconseatbeltWarning.opacity = 0.3
                }
                else if (sig === 0x01) { // 0x03 => seatbelt chưa được đóng
//                    iconseatbeltWarning.visible = true
                    seatbeltWarningTimer.running = true
                }
            }
        }

        // Timer để nhấp nháy icon 100ms
        Timer {
            id: seatbeltWarningTimer
            interval: 100    // 500ms → on/off → chu kỳ 100ms
            repeat: true
            running: false
            onTriggered: {
                iconseatbeltWarning.opacity = iconseatbeltWarning.opacity < 1 ? 1 : 0.3
            }
        }

        // Icon
        Image {
            id: iconseatbeltWarning
            anchors.centerIn: parent
            source: "/assert/Dash_board/Seatbelt.png"
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
//            visible: false   // mặc định tắt
            opacity:0.3
        }

        // màu nền cho dễ debug
//        Rectangle { anchors.fill: parent; color: "#40ffffff" }
    }

    // Thêm icon đèn pha xe
    Item {
        id: headLight
        property alias iconSource: iconheadLight.source   // cho phép set icon từ ngoài
        property real baseX: 101
        property real baseY: 6
        property real baseWidth: 55
        property real baseHeight: 54

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconheadLight
            anchors.centerIn: parent
            source: "/assert/Dash_board/Headlight.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
//            visible: false
            opacity:0.3
        }
    }

    // thêm minimap demo (sẽ phát triển dữ liệu thật sau)
    Item {
        id: miniMap
        property alias iconSource: iconminiMap.source   // cho phép set icon từ ngoài
        property real baseX: 365
        property real baseY: 71
        property real baseWidth: 428
        property real baseHeight: 200

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: iconminiMap
            anchors.centerIn: parent
            source: "/assert/Dash_board/Map Demo.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width
            height: parent.height
        }

        // Để dễ debug, bạn có thể bật màu nền nhẹ
//        Rectangle { anchors.fill: parent; color: "#40ffffff" }
    }

    // ô vuông chọn biểu tượng sưởi ấm vô lăng
    Item {
        id: selectSteeringwheelwarmer
        property real baseX: 362
        property real baseY: 291
        property real baseWidth: 85
        property real baseHeight: 86

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        Rectangle {
            id: selectSteeringwheelwarmerRectangle
            anchors.fill: parent;
            color: "#40ffffff"
            opacity: 0.0 // mặc định ban đầu không hiển thị (không chọn gì cả)
//            Giá trị	|   Ý nghĩa
//            opacity: 1.0	Hoàn toàn không trong suốt (hiển thị bình thường)
//            opacity: 0.5	Trong suốt 50%
//            opacity: 0.0	Trong suốt hoàn toàn, không nhìn thấy (nhưng item vẫn chiếm diện tích và vẫn nhận sự kiện chuột nếu visible: true)
            radius: 10

            border.width: 2          // độ dày đường viền
            border.color: "grey"    // màu đường viền
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn
                selectSteeringwheelwarmerRectangle.opacity = 0.5 - selectSteeringwheelwarmerRectangle.opacity

            }
        }
    }
    // ô vuông chọn biểu tượng sưởi ấm kính trước
    Item {
        id: selectFrontDefrosh
        property real baseX: 448
        property real baseY: 291
        property real baseWidth: 85
        property real baseHeight: 86

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        Rectangle {
            id: selectFrontDefroshRectangle
            anchors.fill: parent;
            color: "#40ffffff"
            opacity: 0.0 // mặc định ban đầu không hiển thị (không chọn gì cả)
//            Giá trị	|   Ý nghĩa
//            opacity: 1.0	Hoàn toàn không trong suốt (hiển thị bình thường)
//            opacity: 0.5	Trong suốt 50%
//            opacity: 0.0	Trong suốt hoàn toàn, không nhìn thấy (nhưng item vẫn chiếm diện tích và vẫn nhận sự kiện chuột nếu visible: true)
            radius: 10

            border.width: 2          // độ dày đường viền
            border.color: "grey"    // màu đường viền
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn
                selectFrontDefroshRectangle.opacity = 0.5 - selectFrontDefroshRectangle.opacity
            }
        }
    }
    // ô vuông chọn biểu tượng sưởi ấm kính rear
    Item {
        id: selectRearDefrosh
        property real baseX: 534
        property real baseY: 291
        property real baseWidth: 85
        property real baseHeight: 86

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        Rectangle {
            id: selectRearDefroshRectangle
            anchors.fill: parent;
            color: "#40ffffff"
            opacity: 0.0 // mặc định ban đầu không hiển thị (không chọn gì cả)
//            Giá trị	|   Ý nghĩa
//            opacity: 1.0	Hoàn toàn không trong suốt (hiển thị bình thường)
//            opacity: 0.5	Trong suốt 50%
//            opacity: 0.0	Trong suốt hoàn toàn, không nhìn thấy (nhưng item vẫn chiếm diện tích và vẫn nhận sự kiện chuột nếu visible: true)
            radius: 10

            border.width: 2          // độ dày đường viền
            border.color: "grey"    // màu đường viền
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn
                selectRearDefroshRectangle.opacity = 0.5 - selectRearDefroshRectangle.opacity
            }
        }
    }

    // ô vuông chọn biểu tượng sưởi ấm ghế lái
    Item {
        id: selectSeatWarmer
        property real baseX: 620
        property real baseY: 291
        property real baseWidth: 85
        property real baseHeight: 86

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        Rectangle {
            id: selectSeatWarmerRectangle
            anchors.fill: parent;
            color: "#40ffffff"
            opacity: 0.0 // mặc định ban đầu không hiển thị (không chọn gì cả)
//            Giá trị	|   Ý nghĩa
//            opacity: 1.0	Hoàn toàn không trong suốt (hiển thị bình thường)
//            opacity: 0.5	Trong suốt 50%
//            opacity: 0.0	Trong suốt hoàn toàn, không nhìn thấy (nhưng item vẫn chiếm diện tích và vẫn nhận sự kiện chuột nếu visible: true)
            radius: 10

            border.width: 2          // độ dày đường viền
            border.color: "grey"    // màu đường viền
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn
                selectSeatWarmerRectangle.opacity = 0.5 - selectSeatWarmerRectangle.opacity
            }
        }
    }

    // ô vuông chọn biểu tượng sưởi ấm Wiper
    Item {
        id: selectWiper
        property real baseX: 706
        property real baseY: 291
        property real baseWidth: 85
        property real baseHeight: 86

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        Rectangle {
            id: selectWiperRectangle
            anchors.fill: parent;
            color: "#40ffffff"
            opacity: 0.0 // mặc định ban đầu không hiển thị (không chọn gì cả)
//            Giá trị	|   Ý nghĩa
//            opacity: 1.0	Hoàn toàn không trong suốt (hiển thị bình thường)
//            opacity: 0.5	Trong suốt 50%
//            opacity: 0.0	Trong suốt hoàn toàn, không nhìn thấy (nhưng item vẫn chiếm diện tích và vẫn nhận sự kiện chuột nếu visible: true)
            radius: 10

            border.width: 2          // độ dày đường viền
            border.color: "grey"    // màu đường viền
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn
                selectWiperRectangle.opacity = 0.5 - selectWiperRectangle.opacity
            }
        }
    }



}
