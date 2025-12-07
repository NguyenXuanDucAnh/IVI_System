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


/**
 * explicit: dùng để ngăn constructor bị gọi thông qua ép kiểu ngầm định, giúp code an toàn và rõ ràng hơn.
 * QObject* parent = nullptr: giúp Qt tự quản lý bộ nhớ, tự hủy object con, tự ngắt signal/slot, đồng thời vẫn cho phép object hoạt động độc lập khi không có cha.
 */
