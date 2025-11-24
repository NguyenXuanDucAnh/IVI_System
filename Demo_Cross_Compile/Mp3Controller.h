#ifndef MP3CONTROLLER_H
#define MP3CONTROLLER_H


#pragma once
#include <QObject>
#include <QStringList>
#include <QDBusInterface>
#include <QDebug>

#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusReply>

class Mp3Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentSong READ currentSong NOTIFY currentSongChanged)
public:
    explicit Mp3Controller(QObject *parent = nullptr);

    Q_INVOKABLE void playPause();
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void setVolume(double vol);
    Q_INVOKABLE QStringList getSongList();

    QString currentSong() const { return m_currentSong; }

signals:
    void currentSongChanged();

private:
    QStringList m_songs;     // danh sách bài hát
    int m_index = -1;         // index bài hát hiện tại
    bool m_playing = false;   // trạng thái đang phát hay tạm dừng
    QString m_currentSong;    // tên bài hát hiện tại

    QDBusInterface m_mp3Interface;
};



#endif // MP3CONTROLLER_H
