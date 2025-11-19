#ifndef VEHICLELISTENER_H
#define VEHICLELISTENER_H

#include <QObject>
#include <QString>

class VehicleListener : public QObject
{
    Q_OBJECT
public:
    explicit VehicleListener(QObject* parent = nullptr);
    void init();

signals:
    void newData(QString value);

public slots:
    void onDataUpdated(QString value);
};

#endif // VEHICLELISTENER_H
