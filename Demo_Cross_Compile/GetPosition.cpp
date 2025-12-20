#include "GetPosition.h"
#include <stdexcept> // Recommended for standard exceptions
#include <iostream>


// GetPositon::GetPositon(QObject *parent): QObject(parent),
//                         m_GetPositonInterface ("org.example.MapsOffline",
//                                                     "/org/example/MapsOffline",
//                                                     "org.example.MapsOffline" ,
//                                                     QDBusConnection::sessionBus()
//                         )
// {
//     // Lấy danh sách bài hát từ D-Bus
//     QDBusReply<QString> reply = m_GetPositonInterface.call("GetLatLon");
//     if(reply.isValid()) {
//         LatLonStr = reply.value();
//         qDebug() << "Get string latlon:" << LatLonStr;
//     } else {
//         qWarning() << "Failed to get lat lon list:" << reply.error().message();
//     }

//     getLat();
//     getLon();
// }

// void GetPositon::getLat(){
//     int index = 0;
//     int count_char = 0;
//     QString buffer;
//     double temp_lat = 0.00;
//     while (index < LatLonStr.size() && count_char < 1)
//     {
//         buffer[index] = LatLonStr[index];
//         index++;
//         if (LatLonStr[index] == ',')
//         {
//             count_char++;
//         }
//     }
//     qDebug() << "Buffer: " << buffer;
//     temp_lat = buffer.toDouble();
//     qDebug() << "temp_lat: " << temp_lat;
//     emit update_lat_lon();
// }

// void GetPositon::getLon(){
//     int index = 0;
//     int count_char = 0;
//     QString buffer; int index_buffer = 0;
//     double temp_lon = 0.00;
//     while (index < LatLonStr.size())
//     {
//         index++;
//         if (LatLonStr[index] == ',')
//         {
//             count_char++;
//         }
//         else if (LatLonStr[index] == '@')
//         {
//             break;
//         }
//         else if (LatLonStr[index] != ',' && count_char == 1)
//         {
//             buffer[index_buffer] = LatLonStr[index];
//             index_buffer++;
//         }
//     }
//     qDebug() << "Buffer: " << buffer;
//     temp_lon = buffer.toDouble();
//     qDebug() << "temp_lon: " << temp_lon;
//     emit update_lat_lon();
// }


GetPositon::GetPositon(QObject* parent) : QObject(parent)
{
}

void GetPositon::init(){
    bool ok = QDBusConnection::sessionBus().connect(
        "org.example.MapsOffline",       // service
        "/org/example/MapsOffline",      // object path
        "org.example.MapsOffline",       // interface
        "DataMapUpdated",               // signal
        this, SLOT(onDataUpdated(QString))
    );

    if (!ok)
        qWarning() << "Cannot connect D-Bus signal";
}

void GetPositon::onDataUpdated(QString value)
{
    // qDebug() << "D-Bus Maps Data:" << value;
    // emit update_lat_lon();
    processLatLon(value);
}

void GetPositon::processLatLon(QString LatLonStr_){

    LatLonStr = LatLonStr_;

    // ✅ ĐÚNG:
    QStringList parts = LatLonStr.split(",");
    if (parts.size() == 2) {  // Kiểm tra trước!
        bool ok1, ok2;
        double lat = parts[0].trimmed().toDouble(&ok1);
        double lon = parts[1].trimmed().toDouble(&ok2);

        if (ok1 && ok2) {
            latCur = lat;
            lonCur = lon;
        }
    } else {
        qWarning() << "Invalid format, expected 'lat, lon':" << LatLonStr;
    }

    // qDebug() << "latCur: " << latCur;
    // qDebug() << "lonCur: " << lonCur;
    emit update_data_UI();
} 

// EOF
