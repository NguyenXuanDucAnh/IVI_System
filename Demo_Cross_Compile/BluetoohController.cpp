#include "BluetoothController.h"

#include <QDBusConnection>
#include <QDebug>

bluetoothcontroller::bluetoothcontroller(QObject* parent) : QObject(parent)
{
    bool ok = QDBusConnection::sessionBus().connect(
        "org.example.Vehicle",       // service
        "/org/example/Vehicle",      // object path
        "org.example.Vehicle",       // interface
        "DataUpdated"               // signal
    );

    if (ok == false)
    {
        qDebug() << "No connect to D-Bus Bluetooth service";
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

} // play audio đang dạy
void bluetoothcontroller::PauseAudio()
{

} // tạm dừng audio đang chạy
void bluetoothcontroller::NextTrack()
{

} // chuyển trang audio kế tiếp
void bluetoothcontroller::PreviousTrack()
{

} // chuyển lại audio trước đó
void bluetoothcontroller::SetVolume (double volume)
{

} // set volume ở mức mong muốn (0.0-> 10.0)
double bluetoothcontroller::GetCurrentVolume ()
{
    return 0.0;
} // lấy mức volume hiện tại

QString bluetoothcontroller::GetMetadata()
{
    QString bufferRet;

    emit GetMetadataDone ();
    return bufferRet;
}
