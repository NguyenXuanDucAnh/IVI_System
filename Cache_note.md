### đường dẫn tới file qmake thực thi: ./home/admin1/Downloads/qt5.15/qt-everywhere-src-5.15.0/qtbase/qmake/qmake

### /Desktop/QT/Test_cross_compile_project_rpi/test_cross_compile_project

---
# Link này chứa một vài video ytb khá hay để dùng được usb GPS VK-162:
### link: https://dientutuyetnga.com/products/vk-162-module-dinh-vi-gps-cho-google-earth

---

# Định nghĩa dữ liệu ECU và Pi
- "###" + "Toc Do:" + byte_H + byte_L + "###\n": 23 23 23 54 6F 63 20 44 6F 3A + byte_H + byte_L + 23 23 23 0A
- "RPM:" + byte_H + byte_L : 52 50 4D 3A + 
- "Celsius:" + byte_H + byte_L: 43 65 6C 73 69 75 73 3A



---


#
Column {
        spacing: 10
        width: 400

        Text {
            id: songName
            text: mp3Ctrl.currentSong
            font.pixelSize: 24
        }

        Row {
            spacing: 20
            Button { text: "Previous"; onClicked: mp3Ctrl.previous() }
            Button { text: "Play/Pause"; onClicked: mp3Ctrl.playPause() }
            Button { text: "Next"; onClicked: mp3Ctrl.next() }
        }

        Slider {
            id: volumeSlider
            from: 0; to: 10; value: 1
            onValueChanged: mp3Ctrl.setVolume(value)
        }

        ListView {
            id: songList
            width: parent.width
            height: 200
            model: mp3Ctrl.getSongList()
            delegate: Rectangle {
                width: parent.width
                height: 40
                Text { text: modelData }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mp3Ctrl.play(modelData)    // phát bài được chọn
                        // mp3Ctrl.playPause()      // nếu muốn tạm dừng/play, dùng riêng
                    }
                }
            }
        }
    }