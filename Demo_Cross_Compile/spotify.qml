import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    width: 1024
    height: 600
    anchors.fill: parent

    Image {
        anchors.fill: parent
        source: "assert/Dash_board/Back_ground.png"
        fillMode: Image.PreserveAspectCrop
    }

    Text {
        anchors.centerIn: parent
        text: "Spotify App Screen"
        font.pixelSize: 50
        color: "white"
    }

    // Nút Back về Dashboard
    Item {
        x: 10; y: 10; width: 80; height: 80
        Image { anchors.fill: parent; source: "assert/App Home Icon.png"; fillMode: Image.PreserveAspectFit }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                stackView.pop()   // quay lại Dashboard
            }
        }
    }
}
