#ifndef GETPOSITION_H
#define GETPOSITION_H


#include <QObject>
#include <QStringList>
#include <QDBusInterface>
#include <QDebug>

#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusReply>

// class GetPositon : public QObject
// {
//     Q_OBJECT
//     Q_PROPERTY(double currentLat READ currentLat NOTIFY update_lat_lon)
//     Q_PROPERTY(double currentLon READ currentLon NOTIFY update_lat_lon)
// public:
//     explicit GetPositon(QObject *parent = nullptr);
//     Q_INVOKABLE void getLat();
//     Q_INVOKABLE void getLon();

//     double currentLat() const { return lat; };
//     double currentLon() const { return lon; };

// signals:
//     void update_lat_lon ();

// private:
//     double lat;
//     double lon;
//     QString LatLonStr;

//     QDBusInterface m_GetPositonInterface;

// };

class GetPositon : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double currentLat READ currentLat NOTIFY update_data_UI)
    Q_PROPERTY(double currentLon READ currentLon NOTIFY update_data_UI)
    // Q_PROPERTY(double currentLon READ currentLon NOTIFY update_lat_lon)

private:
    double latCur;
    double lonCur;
    QString LatLonStr;

    Q_INVOKABLE void processLatLon(QString LatLonStr_);

public:
    explicit GetPositon(QObject *parent = nullptr);
    Q_INVOKABLE void init();

    Q_INVOKABLE double currentLat() const { return latCur; };
    Q_INVOKABLE double currentLon() const { return lonCur; };

signals:
    void update_lat_lon ();
    void update_data_UI();

public slots:
    Q_INVOKABLE void onDataUpdated (QString newData);

};



#endif // GETPOSITION_H
