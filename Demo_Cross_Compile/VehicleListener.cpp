#include "VehicleListener.h"
#include <QDBusConnection>
#include <QDebug>

VehicleListener::VehicleListener(QObject* parent) : QObject(parent)
{
}

void VehicleListener::init()
{
    bool ok = QDBusConnection::sessionBus().connect(
        "org.example.Vehicle",       // service
        "/org/example/Vehicle",      // object path
        "org.example.Vehicle",       // interface
        "DataUpdated",               // signal
        this, SLOT(onDataUpdated(QString))
    );

    if (!ok)
        qWarning() << "Cannot connect D-Bus signal";
}

void VehicleListener::onDataUpdated(QString value)
{
//    qDebug() << "D-Bus Data:" << value;
    emit newData(value);
}
