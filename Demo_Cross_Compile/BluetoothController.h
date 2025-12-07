#ifndef BLUETOOTHCONTROLLER_H
#define BLUETOOTHCONTROLLER_H



#include <QObject>
#include <QString>

#include <QDBusConnection>
#include <QDebug>

// class VehicleListener : public QObject
// {
//     Q_OBJECT
// public:
//     explicit VehicleListener(QObject* parent = nullptr);
//     void init();

// signals:
//     void newData(QString value);

// public slots:
//     void onDataUpdated(QString value);
// };

class bluetoothcontroller : public QObject
{
    Q_OBJECT
public:
    explicit bluetoothcontroller(QObject* parent = nullptr);

signals:
    void GetMetadataDone ();
    void OnDataUpdated ();
    
public slots:
    void TurnOnBlue(); // bật BLE lên (power on)
    void TurnOffBlue(); // tắt BLE đi (power off)
    void PlayAudio (); // play audio đang dạy
    void PauseAudio(); // tạm dừng audio đang chạy
    void NextTrack(); // chuyển trang audio kế tiếp
    void PreviousTrack(); // chuyển lại audio trước đó
    void SetVolume (double volume); // set volume ở mức mong muốn (0.0-> 10.0)
    double GetCurrentVolume (); // lấy mức volume hiện tại
    QString GetMetadata (); // Lấy dữ liệu metadata
    /* Ví dụ chuỗi meta data:
            array [
            dict entry(
                string "Title"
                string "Learn To Introduce Yourself"
            )
            dict entry(
                string "Artist"
                string "LEP - Learn English Podcast"
            )
            dict entry(
                string "Album"
                string "LEP - Learn English Podcast"
            )
        ]
    */
};



#endif // BLUETOOTHCONTROLLER_H
