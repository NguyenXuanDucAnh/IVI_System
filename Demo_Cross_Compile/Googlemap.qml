import QtQuick 2.15
import QtQuick.Window 2.15

import QtLocation 5.15
import QtPositioning 5.15

Item {
    width: 1024
    height: 600
    anchors.fill: parent

    // thêm background
    Image {
        id: background
        source: "assert/Google Map/Back_Ground_Music_Tab.png"
        anchors.fill: parent
        fillMode: Image.Stretch
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
                // thực hiện hành động bạn muốn
                stackView.push ('Dashboard.qml')
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

    // -- thêm block google map pannel
    Item {
        Item {
            id: mapWindows
    //       property real baseX: 361
    //       property real baseY: 75
    //       property real baseWidth: 638
    //       property real baseHeight: 391
            property real baseX: 700
            property real baseY: 150
            property real baseWidth: 1100
            property real baseHeight: 700

        x: baseX
        y: baseY
        width: baseWidth
        height: baseHeight
    //        x: baseX * (background.width / background.sourceSize.width)
    //        y: baseY * (background.height / background.sourceSize.height)
    //        width: baseWidth * (background.width / background.sourceSize.width)
    //        height: baseHeight * (background.height / background.sourceSize.height)

            property double testLat: 21.0222//21.007376
            property double testLon: 105.66//105.663766
            property int testZoom: 16

            // Cập nhật vị trí lat/lon liên tục
            Plugin {
                id: mapPlugin
                name: "osm"
                PluginParameter {
                    name: "osm.mapping.cache.directory"
                    value: "/home/root/.cache/qtlocation/osm"
                }
            }

            Rectangle { anchors.fill: parent; color: "#40ffffff" }

            // Container cho Map để dễ chỉnh kích thước
            Rectangle {
                id: mapContainer
                anchors.fill: parent
                anchors.margins: 0
                x: mapWindows.baseX
                y: mapWindows.baseY
                width: mapWindows.baseWidth
                height: mapWindows.baseHeight

                color: "transparent"
    //            border.color: "#333333"
                border.color: "red"
                border.width: 2
                radius: 10  // Bo góc

                Map {
                    id: mapAtlast
                    anchors.fill: parent
                    anchors.margins: 5  // Margin để không bị border che
                    plugin: mapPlugin
                    zoomLevel: testZoom
                    center: QtPositioning.coordinate(getPostion.currentLat, getPostion.currentLon)


                    // Draw tracker
                    MapQuickItem {
                        coordinate: QtPositioning.coordinate(getPostion.currentLat, getPostion.currentLon)
                        anchorPoint.x: 12
                        anchorPoint.y: 12
                        sourceItem: Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "red"
                            border.color: "white"
                            border.width: 2

                            // Animation khi di chuyển
                            Behavior on x {
                                NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad }
                            }
                            Behavior on y {
                                NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad }
                            }
                        }
                    }
                }
            }

        }

        // thêm nút về giữa của google map
        Item {
            id: centerMapButton
            property alias iconSource: iconCenterMapButton.source   // cho phép set icon từ ngoài
            property real baseX: 390
            property real baseY: 420
            property real baseWidth:  103.2
            property real baseHeight:  34.4

            x: baseX * (background.width / background.sourceSize.width)
            y: baseY * (background.height / background.sourceSize.height)
            width: baseWidth * (background.width / background.sourceSize.width)
            height: baseHeight * (background.height / background.sourceSize.height)

            // vẽ viền
            Rectangle {
                anchors.fill: parent
//                color: "black"
                border.color: "black"
                border.width: 2
                radius: 6
            }

            // Icon
            Image {
                id: iconCenterMapButton
                anchors.centerIn: parent
                source: "assert/Google Map/MapCenterButton.png"  // thay bằng đường dẫn icon của bạn
                fillMode: Image.PreserveAspectFit
                width: parent.width
                height: parent.height
            }

            // MouseArea để bắt sự kiện nhấn
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    console.log("Icon button clicked!")
                    // thực hiện hành động bạn muốn
                    if (mapAtlast.zoomLevel === 20) {
                        mapAtlast.zoomLevel = 16
                    } else {
                        mapAtlast.zoomLevel = 20
                    }
                }
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
}

//import QtQuick 2.15
//import QtLocation 5.15
//import QtPositioning 5.15

//Item {
//    anchors.fill: parent

//    property double testLat: 21.0222//21.007376
//    property double testLon: 105.66//105.663766
//    property int testZoom: 14

//    // Cập nhật vị trí lat/lon liên tục
//    Plugin {
//        id: mapPlugin
//        name: "osm"

//        PluginParameter {
//            name: "osm.mapping.cache.directory"
//            value: "/home/root/.cache/qtlocation/osm"
//        }
//    }

//    // Container cho Map để dễ chỉnh kích thước
//    Rectangle {
//        id: mapContainer

//        // Chỉnh kích thước và vị trí của bản đồ ở đây
//        width: parent.width * 1.0  // 100% chiều rộng
//        height: parent.height * 1.0  // 100% chiều cao
//        anchors.centerIn: parent     // Căn giữa

//        // Hoặc có thể set kích thước cố định:
//        // width: 800
//        // height: 600
//        // x: 100
//        // y: 50

//        color: "transparent"
//        border.color: "#333333"
//        border.width: 2
//        radius: 10  // Bo góc

//        Map {
//            anchors.fill: parent
//            anchors.margins: 2  // Margin để không bị border che
//            plugin: mapPlugin
//            zoomLevel: testZoom
//            center: QtPositioning.coordinate(getPostion.currentLat, getPostion.currentLon)

//            MapQuickItem {
//                coordinate: QtPositioning.coordinate(getPostion.currentLat, getPostion.currentLon)
//                anchorPoint.x: 12
//                anchorPoint.y: 12
//                sourceItem: Rectangle {
//                    width: 24
//                    height: 24
//                    radius: 12
//                    color: "red"
//                    border.color: "white"
//                    border.width: 2

//                    // Animation khi di chuyển
//                    Behavior on x {
//                        NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad }
//                    }
//                    Behavior on y {
//                        NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad }
//                    }
//                }
//            }
//        }
//    }

//}
