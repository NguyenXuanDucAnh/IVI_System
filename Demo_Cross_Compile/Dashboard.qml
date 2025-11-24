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
        fillMode: Image.PreserveAspectCrop  // hoặc .Stretch nếu muốn kéo giãn đầy đủ
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
        property real baseX: 220
        property real baseY: 65
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
        property real baseX: 15
        property real baseY: 65
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
        property real baseX: 102
        property real baseY: 40
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
            font.pixelSize: 55 * (background.width / background.sourceSize.width)
            color: "white"
            text: uartProvider.speed_info
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

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
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

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
        }
    }
    // -- thêm icon bluetooth app
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
            }
        }

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
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

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
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

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
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

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
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

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
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

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
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
            text: mp3Ctrl.currentSong // lấy tên bài hát hiện tại
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
                mp3Ctrl.playPause()
                playMusic.active = !playMusic.active
            }
        }

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
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
                mp3Ctrl.next()
            }
        }

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
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
                mp3Ctrl.previous()
            }
        }

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
        }
    }

    // thêm phần điều chỉnh volume âm nhạc
    Slider {
        id: volumeSlider
        property real baseX: 863
        property real baseY: 63
        property real baseWidth: 140

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)

        from: 0; to: 10; value: 10.0
        onValueChanged: mp3Ctrl.setVolume(value)
    }

    // thêm Icon/nút tăng âm lượng
    Item {
        id: increaseVolume
        property alias iconSource: iconIncreaseVolume.source   // cho phép set icon từ ngoài
        property real baseX: 1000
        property real baseY: 63
        property real baseWidth: 24
        property real baseHeight: 19

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

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
        }
    }
    // thêm Icon/nút giảm lượng
    Item {
        id: decreaseVolume
        property alias iconSource: iconDecreaseVolume.source   // cho phép set icon từ ngoài
        property real baseX: 840
        property real baseY: 63
        property real baseWidth: 24
        property real baseHeight: 19

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

        // Optional: nền nhấn phản hồi (effect khi hover)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: mouseArea.containsMouse ? "white" : "transparent"
            radius: width / 2
        }
    }



}
