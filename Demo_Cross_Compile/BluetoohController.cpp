#include "BluetoothController.h"

#include <QDBusConnection>
#include <QDebug>

#include <QMap>
#include <QDBusMetaType>
#include <QtDBus/QDBusMetaType>
#include <QString>

#define MAX_LEGHT_NAME_TRACK 50

typedef QMap<QString, QString> ConnectionDetails;
Q_DECLARE_METATYPE(ConnectionDetails)

bluetoothcontroller::bluetoothcontroller(QObject* parent) : QObject(parent),
                        m_BleAudioInterface ("com.example.BluetoothAudio", 
                            "/com/example/BluetoothAudio", 
                            "com.example.BluetoothAudio" , 
                            QDBusConnection::sessionBus()
                        )
{
    // // Lấy meta data từ Bluetooth Service custom
    // QDBusReply<QString> reply = m_BleAudioInterface.call("GetMetadata");
    // if(reply.isValid()) {
    //     qDebug () << reply.value() << "\n";
    // } else {
    //     qWarning() << "Failed to get song list:" << reply.error().message();
    // }

    // QDBusInterface m_BleAudioInterface(
    //     "com.example.BluetoothAudio",
    //     "/com/example/BluetoothAudio",
    //     "com.example.BluetoothAudio",
    //     QDBusConnection::sessionBus()
    // );
    // ✅ BẮT BUỘC để dùng a{ss}
    qDBusRegisterMetaType<QMap<QString, QString>>();

    if (!m_BleAudioInterface.isValid()) {
        qDebug() << "DBus interface invalid!";
        return;
    }

    // ✅ a{ss}  →  QMap<QString, QString>
    QDBusReply<QMap<QString, QString>> reply =
            m_BleAudioInterface.call("GetMetadata");

    if (!reply.isValid()) {
        qDebug() << "DBus Error:" << reply.error().message();
        return;
    }

    QMap<QString, QString> metadata = reply.value();

    qDebug() << "Title :"  << metadata.value("Title");
    qDebug() << "Artist:"  << metadata.value("Artist");
    qDebug() << "Album :"  << metadata.value("Album");

    // Debug toàn bộ map
    qDebug() << "Full metadata:" << metadata;

    // current_audio = metadata.value("Title") + "-" + metadata.value("Artist");

    UpdateCurrentAudioName (metadata);

    
}

void bluetoothcontroller::UpdateCurrentAudioName (QMap<QString, QString> metadata)
{
    QString fullText = metadata.value("Title") + "-" + metadata.value("Artist");

    if (fullText.length() > MAX_LEGHT_NAME_TRACK) {
        current_audio = fullText.left(MAX_LEGHT_NAME_TRACK) + "...";  // "Example..."
    } else {
        current_audio = fullText;
    }
}

void bluetoothcontroller::TurnOnBlue()
{

}

void bluetoothcontroller::TurnOffBlue()
{

}

void bluetoothcontroller::PlayAudio ()
{
    m_BleAudioInterface.call("Play");
} // play audio đang dạy
void bluetoothcontroller::PauseAudio()
{
    m_BleAudioInterface.call("Pause");
} // tạm dừng audio đang chạy

void bluetoothcontroller::TogglePlayPause()
{
    m_BleAudioInterface.call("PlayPause");
}
void bluetoothcontroller::NextTrack()
{
    m_BleAudioInterface.call("Next");
    GetMetadata();
} // chuyển trang audio kế tiếp
void bluetoothcontroller::PreviousTrack()
{
    m_BleAudioInterface.call("Previous");
    GetMetadata();
} // chuyển lại audio trước đó
void bluetoothcontroller::SetVolume (double volume)
{
    m_BleAudioInterface.call("SetVolume", volume);
} // set volume ở mức mong muốn (0.0-> 10.0)
double bluetoothcontroller::GetCurrentVolume ()
{
    
    return 0.0;
} // lấy mức volume hiện tại


QString bluetoothcontroller::GetMetadata()
{
    QString bufferRet;
    if (!m_BleAudioInterface.isValid()) {
        qDebug() << "DBus interface invalid!";
        return "";
    }

    // ✅ a{ss}  →  QMap<QString, QString>
    QDBusReply<QMap<QString, QString>> reply =
            m_BleAudioInterface.call("GetMetadata");

    if (!reply.isValid()) {
        qDebug() << "DBus Error:" << reply.error().message();
        return "";
    }

    QMap<QString, QString> metadata = reply.value();

    qDebug() << "Title :"  << metadata.value("Title");
    qDebug() << "Artist:"  << metadata.value("Artist");
    qDebug() << "Album :"  << metadata.value("Album");

    // Debug toàn bộ map
    qDebug() << "Full metadata:" << metadata;

    bufferRet = metadata.value("Title") + "-" + metadata.value("Artist");
    qDebug() << "Full bufferRet:" << bufferRet;

    UpdateCurrentAudioName (metadata);
    emit GetMetadataDone();
    return bufferRet;
}
