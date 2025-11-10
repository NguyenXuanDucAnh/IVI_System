import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    visible: true
    width: 1024
    height: 600
    color: "black"   // đảm bảo Window có màu nền

    // --- Background Image ---
    Image {
        id: background
        source: "assert/Dash_board/Back_ground.png"
        x: 0
        y: 0
    }

//    Image {
//        id: kim_toc_do
//        source: "assert/Dash_board/Kim_Chi_Toc_DODO.png"
//        x: 445
//        y: 148.4
//    }



    // Load font từ file, không có cái này thì không hiện text lên được
    FontLoader {
        id: unitext_regular_font
        source: "Fonts/Unitext Regular.ttf"   // đường dẫn tới font
    }

    // Text sử dụng font vừa load
    Text {
        x: 734
        y: 280
        font.family: unitext_regular_font.name   // dùng font loader
        font.pixelSize: 16
        color: "white"
        text: uartProvider.uartText
    }


    // --- Ảnh kim ---
        Image {
            id: needle
            source: "assert/Dash_board/Kim_Chi_Toc_DODO.png"
            width: 7.2                 // kích thước hiển thị (tuỳ chỉnh)
            height: 81.52
            x: 445
            y: 148.4

            transform: Rotation {
                id: needleRotation
                origin.x: width / 2       // tâm xoay theo chiều ngang (giữa)
                origin.y: height * 0.9    // tâm xoay theo chiều dọc (gần cuối kim)
                angle: needleAngle        // góc xoay (theo biến)
            }
        }

//        // --- Biến điều khiển góc kim ---
//        property real needleAngle: 0

//        // --- Thử thay đổi góc liên tục ---
//        SequentialAnimation on needleAngle {
//            loops: Animation.Infinite
//            NumberAnimation { from: 0; to: 270; duration: 3000; easing.type: Easing.InOutQuad }
//            NumberAnimation { from: 270; to: 0; duration: 3000; easing.type: Easing.InOutQuad }
//        }

        // --- Vẽ tâm kim để dễ căn chỉnh ---
        Rectangle {
            width: 8; height: 8; radius: 4
            color: "red"
            anchors.centerIn: parent
            z: 100
        }

}
