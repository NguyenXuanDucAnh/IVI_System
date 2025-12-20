// import QtQuick

// Window {
//     width: 640
//     height: 480
//     visible: true
//     title: qsTr("Hello World")
// }
import QtQuick 2.15
import QtQuick.Window 2.15
import QtLocation 5.15
import QtPositioning 5.15

Window {
    width: 1000
    height: 800
    visible: true
    title: "Offline Map GPS (Qt)"

    // ====== TOẠ ĐỘ TEST ======
    property double testLat: 21.007376
    property double testLon: 105.663766
    property int testZoom: 20
    // ========================

    Plugin {
        id: mapPlugin
        name: "osm"

        PluginParameter {
            name: "osm.mapping.offline.directory"
            // ⚠️ Windows: dùng / hoặc \\ (KHÔNG dùng \ đơn)
            value: "C:/Users/anhng/Downloads/Mobile Atlas Creator 2.3.3/atlases/maps/osm"
        }

        PluginParameter {
            name: "osm.mapping.providersrepository.disabled"
            value: true
        }
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        zoomLevel: testZoom

        center: QtPositioning.coordinate(testLat, testLon)

        MapQuickItem {
            id: gpsMarker
            anchorPoint.x: 12
            anchorPoint.y: 12
            coordinate: QtPositioning.coordinate(testLat, testLon)

            sourceItem: Rectangle {
                width: 24
                height: 24
                radius: 12
                color: "red"
                border.color: "white"
                border.width: 2
            }
        }
    }

    // ====== TEST ĐỔI TỌA ĐỘ BẰNG PHÍM ======
    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_1) {
                testLat = 21.01107372394961
                testLon = 105.6606727983931
                console.log("Test Hà Nội")
            }
            if (event.key === Qt.Key_2) {
                testLat = 21.007376
                testLon = 105.663766
                console.log("Test điểm khác")
            }
        }
    }
}
