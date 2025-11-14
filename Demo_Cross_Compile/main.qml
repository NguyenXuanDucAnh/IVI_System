//import QtQuick 2.15
//import QtQuick.Window 2.15

//Window {
//    visible: true
//    width: 1024
//    height: 600
//    color: "black"   // đảm bảo Window có màu nền

//    // --- Background Image ---
//    Image {
//        id: background
//        source: "assert/Dash_board/Back_ground.png"
//        anchors.fill: parent
//        fillMode: Image.PreserveAspectCrop  // hoặc .Stretch nếu muốn kéo giãn đầy đủ
//    }

//    // Load font từ file, không có cái này thì không hiện text lên được
//    FontLoader {
//        id: unitext_regular_font
//        source: "Fonts/Orbitron-VariableFont_wght.ttf"   // đường dẫn tới font
//    }

//    // Text sử dụng font vừa load
//    // --- Text tự co dãn theo ảnh ---
//    Text {
//        id: label
//        // toạ độ gốc trong ảnh thật
//        property real baseX: 740
//        property real baseY: 280

//        // tỉ lệ co giãn theo kích thước ảnh
//        x: baseX * (background.width / background.sourceSize.width)
//        y: baseY * (background.height / background.sourceSize.height)

//        font.family: unitext_regular_font.name
//        font.pixelSize: 16 * (background.width / background.sourceSize.width)
//        color: "white"
//        text: uartProvider.Temperature_oil_info
//    }

//    Item {
//        id: speedItem
//        // toạ độ gốc trong ảnh thật
//        property real baseX: 463
//        property real baseY: 220
//        property real baseWidth: 100      // bạn có thể chỉnh kích thước vùng hiển thị
//        property real baseHeight: 60

//        // Tỉ lệ co giãn theo kích thước ảnh nền
//        x: baseX * (background.width / background.sourceSize.width)
//        y: baseY * (background.height / background.sourceSize.height)
//        width: baseWidth * (background.width / background.sourceSize.width)
//        height: baseHeight * (background.height / background.sourceSize.height)

//        // Để dễ debug, bạn có thể bật màu nền nhẹ
////         Re   ctangle { anchors.fill: parent; color: "#40ffffff" }

//        Text {
//            id: label_speed
//            anchors.centerIn: parent        // ✅ canh giữa trong Item
//            font.family: unitext_regular_font.name
//            font.pixelSize: 55 * (background.width / background.sourceSize.width)
//            color: "white"
//            text: uartProvider.speed_info
//            horizontalAlignment: Text.AlignHCenter
//            verticalAlignment: Text.AlignVCenter
//        }
//    }
//    // -- thêm icon Home app => đưa về màn hình dashboard
//    Item {
//        id: homeApp
//        property alias iconSource: iconHomeApp.source   // cho phép set icon từ ngoài
//        property real baseX: 11
//        property real baseY: 518
//        property real baseWidth: 77
//        property real baseHeight: 75

//        x: baseX * (background.width / background.sourceSize.width)
//        y: baseY * (background.height / background.sourceSize.height)
//        width: baseWidth * (background.width / background.sourceSize.width)
//        height: baseHeight * (background.height / background.sourceSize.height)

//        // Icon
//        Image {
//            id: iconHomeApp
//            anchors.centerIn: parent
//            source: "assert/App Home Icon.png"  // thay bằng đường dẫn icon của bạn
//            fillMode: Image.PreserveAspectFit
//            width: parent.width * 0.8
//            height: parent.height * 0.8
//        }

//        // MouseArea để bắt sự kiện nhấn
//        MouseArea {
//            anchors.fill: parent
//            cursorShape: Qt.PointingHandCursor
//            onClicked: {
//                console.log("Icon button clicked!")
//                // thực hiện hành động bạn muốn
//            }
//        }

//        // Optional: nền nhấn phản hồi (effect khi hover)
//        Rectangle {
//            anchors.fill: parent
//            color: "transparent"
//            border.color: mouseArea.containsMouse ? "white" : "transparent"
//            radius: width / 2
//        }
//    }
//    // -- thêm icon Mapp app
//    Item {
//        id: mapApp
//        property alias iconSource: iconMapApp.source   // cho phép set icon từ ngoài
//        property real baseX: 113
//        property real baseY: 521
//        property real baseWidth: 77
//        property real baseHeight: 75

//        x: baseX * (background.width / background.sourceSize.width)
//        y: baseY * (background.height / background.sourceSize.height)
//        width: baseWidth * (background.width / background.sourceSize.width)
//        height: baseHeight * (background.height / background.sourceSize.height)

//        // Icon
//        Image {
//            id: iconMapApp
//            anchors.centerIn: parent
//            source: "assert/App Map Icon.png"  // thay bằng đường dẫn icon của bạn
//            fillMode: Image.PreserveAspectFit
//            width: parent.width * 0.8
//            height: parent.height * 0.8
//        }

//        // MouseArea để bắt sự kiện nhấn
//        MouseArea {
//            anchors.fill: parent
//            cursorShape: Qt.PointingHandCursor
//            onClicked: {
//                console.log("Icon button clicked!")
//                // thực hiện hành động bạn muốn
//            }
//        }

//        // Optional: nền nhấn phản hồi (effect khi hover)
//        Rectangle {
//            anchors.fill: parent
//            color: "transparent"
//            border.color: mouseArea.containsMouse ? "white" : "transparent"
//            radius: width / 2
//        }
//    }
//    // -- thêm icon bluetooth app
//    Item {
//        id: bluetoothApp
//        property alias iconSource: iconBluetoothApp.source   // cho phép set icon từ ngoài
//        property real baseX: 215
//        property real baseY: 521
//        property real baseWidth: 80
//        property real baseHeight: 80

//        x: baseX * (background.width / background.sourceSize.width)
//        y: baseY * (background.height / background.sourceSize.height)
//        width: baseWidth * (background.width / background.sourceSize.width)
//        height: baseHeight * (background.height / background.sourceSize.height)

//        // Icon
//        Image {
//            id: iconBluetoothApp
//            anchors.centerIn: parent
//            source: "assert/App bluetooth icon.png"  // thay bằng đường dẫn icon của bạn
//            fillMode: Image.PreserveAspectFit
//            width: parent.width * 0.8
//            height: parent.height * 0.8
//        }

//        // MouseArea để bắt sự kiện nhấn
//        MouseArea {
//            anchors.fill: parent
//            cursorShape: Qt.PointingHandCursor
//            onClicked: {
//                console.log("Icon button clicked!")
//                // thực hiện hành động bạn muốn
//            }
//        }

//        // Optional: nền nhấn phản hồi (effect khi hover)
//        Rectangle {
//            anchors.fill: parent
//            color: "transparent"
//            border.color: mouseArea.containsMouse ? "white" : "transparent"
//            radius: width / 2
//        }
//    }

//    // -- thêm icon Spotify app
//    Item {
//        id: spotifyApp
//        property alias iconSource: iconSpotifyApp.source   // cho phép set icon từ ngoài
//        property real baseX: 323
//        property real baseY: 521
//        property real baseWidth: 80
//        property real baseHeight: 80

//        x: baseX * (background.width / background.sourceSize.width)
//        y: baseY * (background.height / background.sourceSize.height)
//        width: baseWidth * (background.width / background.sourceSize.width)
//        height: baseHeight * (background.height / background.sourceSize.height)

//        // Icon
//        Image {
//            id: iconSpotifyApp
//            anchors.centerIn: parent
//            source: "assert/App spotify icon.png"  // thay bằng đường dẫn icon của bạn
//            fillMode: Image.PreserveAspectFit
//            width: parent.width * 0.8
//            height: parent.height * 0.8
//        }

//        // MouseArea để bắt sự kiện nhấn
//        MouseArea {
//            anchors.fill: parent
//            cursorShape: Qt.PointingHandCursor
//            onClicked: {
//                console.log("Icon spotify button clicked!")
//                // thực hiện hành động bạn muốn
//            }
//        }

//        // Optional: nền nhấn phản hồi (effect khi hover)
//        Rectangle {
//            anchors.fill: parent
//            color: "transparent"
//            border.color: mouseArea.containsMouse ? "white" : "transparent"
//            radius: width / 2
//        }
//    }

//    Item {
//        id: rpmItem
//        // toạ độ gốc trong ảnh thật
//        property real baseX: 225
//        property real baseY: 280
//        property real baseWidth: 65      // bạn có thể chỉnh kích thước vùng hiển thị
//        property real baseHeight: 20

//        // Tỉ lệ co giãn theo kích thước ảnh nền
//        x: baseX * (background.width / background.sourceSize.width)
//        y: baseY * (background.height / background.sourceSize.height)
//        width: baseWidth * (background.width / background.sourceSize.width)
//        height: baseHeight * (background.height / background.sourceSize.height)

//        // Để dễ debug, bạn có thể bật màu nền nhẹ
//        // Rectangle { anchors.fill: parent; color: "#40ffffff" }

//        Text {
//            id: label_rpm
//            anchors.centerIn: parent        // ✅ canh giữa trong Item
//            font.family: unitext_regular_font.name
//            font.pixelSize: 16 * (background.width / background.sourceSize.width)
//            color: "white"
//            text: uartProvider.rpm_info
//            horizontalAlignment: Text.AlignHCenter
//            verticalAlignment: Text.AlignVCenter
//        }
//    }

//    // vẽ kim chỉ tốc độ
//    Canvas {
//        id: arcCanvas

//        // --- Tọa độ gốc trong ảnh thật ---
//        property real baseX: 509
//        property real baseY: 263
//        property real baseWidth: 300      // kích thước gốc
//        property real baseHeight: 300

//        // Co giãn theo background
//        x: baseX * (background.width / background.sourceSize.width) - (baseWidth * (background.width / background.sourceSize.width))/2
//        y: baseY * (background.height / background.sourceSize.height) - (baseHeight * (background.height / background.sourceSize.height))/2
//        width: baseWidth * (background.width / background.sourceSize.width)
//        height: baseHeight * (background.height / background.sourceSize.height)

//        property real startAngle: 145
////        property real spanAngle: 0
//        property real lineWidth: 90
//        property color arcColor: "darkgrey"
//        property real maxSpanAngle: 260 // góc từ 0km/h đến 320km/h

//        // Lấy spanAngle từ C++:
//         property real spanAngle: arcCtrl.spanAngle

//        onPaint: {
//            // -- Vẽ cung tròn
//            var ctx = getContext("2d")
//            ctx.reset()
//            ctx.clearRect(0, 0, width, height)

//            ctx.save()
//            ctx.translate(width/2, height/2)        // đặt tâm canvas
//            ctx.beginPath()
//            var radius = Math.min(width, height)/2 - lineWidth
//            ctx.arc(0, 0, radius, startAngle * Math.PI/180, (startAngle + spanAngle) * Math.PI/180)
//            ctx.lineWidth = lineWidth
//            ctx.strokeStyle = arcColor
//            ctx.stroke()

//            // --- Vẽ tâm cung (debug) ---
//            ctx.beginPath()
//            ctx.arc(0, 0, 5, 0, 2*Math.PI)   // chấm tròn bán kính 5
//            ctx.fillStyle = "blue"
//            ctx.fill()

//            ctx.restore()
//        }

//        // Khi spanAngle thay đổi từ C++ → request paint lại
//        Connections {
//            target: arcCtrl
//            onSpanAngleChanged: arcCanvas.requestPaint()
//        }
//    }
//}


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: 1024
    height: 600
    color: "black"

    // StackView để quản lý các màn hình
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "Dashboard.qml"  // màn hình chính (dashboard)
    }
}
