#ifndef BLUETOOTHCONTROLLER_H
#define BLUETOOTHCONTROLLER_H

#include <QObject>
#include <QString>

#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusReply>
#include <QDebug>

class bluetoothcontroller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentAudio READ currentAudio NOTIFY GetMetadataDone)
private:
    QDBusInterface m_BleAudioInterface;
    QString current_audio;
    
public:
    explicit bluetoothcontroller(QObject* parent = nullptr);
    QString currentAudio() const { return current_audio; };

signals:
    void GetMetadataDone ();
    void OnDataUpdated ();
    
public slots:
    Q_INVOKABLE void TurnOnBlue(); // bật BLE lên (power on)
    Q_INVOKABLE void TurnOffBlue(); // tắt BLE đi (power off)
    Q_INVOKABLE void PlayAudio (); // play audio đang dạy
    Q_INVOKABLE void PauseAudio(); // tạm dừng audio đang chạy
    Q_INVOKABLE void TogglePlayPause();
    Q_INVOKABLE void NextTrack(); // chuyển trang audio kế tiếp
    Q_INVOKABLE void PreviousTrack(); // chuyển lại audio trước đó
    Q_INVOKABLE void SetVolume (double volume); // set volume ở mức mong muốn (0.0-> 10.0)
    double GetCurrentVolume (); // lấy mức volume hiện tại
    Q_INVOKABLE QString GetMetadata (); // Lấy dữ liệu metadata
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
