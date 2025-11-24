#include "Mp3Controller.h"

Mp3Controller::Mp3Controller(QObject *parent)
    : QObject(parent),
      m_mp3Interface("org.example.Music",
                      "/org/example/Music",
                      "org.example.Music",
                      QDBusConnection::systemBus())
{
    // Lấy danh sách bài hát từ D-Bus
    QDBusReply<QStringList> reply = m_mp3Interface.call("ListSongs");
    if(reply.isValid()) {
        m_songs = reply.value();
        if(!m_songs.isEmpty()) {
            m_index = 0;
            m_currentSong = m_songs[m_index];
        }
    } else {
        qWarning() << "Failed to get song list:" << reply.error().message();
    }
}

QStringList Mp3Controller::getSongList() {
    return m_songs;
}

void Mp3Controller::playPause() {
    if(m_songs.isEmpty() || !m_mp3Interface.isValid()) return;

    if(m_playing) {
        // Hiện backend chưa có Pause, ta tạm Stop
        m_mp3Interface.call("Pause"); // hoặc bạn có thể viết Pause ở Python backend
        m_playing = false;
    } else {
        m_mp3Interface.call("Play", m_currentSong);
        m_playing = true;
    }
}

void Mp3Controller::next() {
    if(m_songs.isEmpty()) return;
    m_index = (m_index + 1) % m_songs.size();
    m_currentSong = m_songs[m_index];
    emit currentSongChanged();
    m_mp3Interface.call("Play", m_currentSong);
    m_playing = true;
}

void Mp3Controller::previous() {
    if(m_songs.isEmpty()) return;
    m_index = (m_index - 1 + m_songs.size()) % m_songs.size();
    m_currentSong = m_songs[m_index];
    emit currentSongChanged();
    m_mp3Interface.call("Play", m_currentSong);
    m_playing = true;
}

void Mp3Controller::setVolume(double vol) {
    if(m_mp3Interface.isValid())
        m_mp3Interface.call("SetVolume", vol);
}
