import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    width: 1024
    height: 600
    anchors.fill: parent

    // thêm background
    Image {
        id: background
        anchors.fill: parent
        source: "assert/Google Map/Back_Ground_Music_Tab.png"
        fillMode: Image.PreserveAspectCrop
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
                stackView.pop()   // quay lại Dashboard
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

    // -- thêm block google map pannel
    Item {
        id: googleMapPannel
        property alias iconSource: iconHomeApp.source   // cho phép set icon từ ngoài
        property real baseX: 361
        property real baseY: 75
        property real baseWidth: 638
        property real baseHeight: 391

        x: baseX * (background.width / background.sourceSize.width)
        y: baseY * (background.height / background.sourceSize.height)
        width: baseWidth * (background.width / background.sourceSize.width)
        height: baseHeight * (background.height / background.sourceSize.height)

        // Icon
        Image {
            id: pannelMap
            anchors.centerIn: parent
            source: "assert/Google Map/Google Map Panel.png"  // thay bằng đường dẫn icon của bạn
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        // MouseArea để bắt sự kiện nhấn
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // thực hiện hành động bạn muốn khi nhấn vào đây
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
