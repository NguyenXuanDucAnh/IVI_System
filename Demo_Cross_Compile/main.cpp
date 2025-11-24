
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusReply>
#include <QDebug>

#include "UartDataProvider.h"
#include "arccontroller.h"
#include "VehicleListener.h"
#include "Mp3Controller.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // khai báo các object
    ArcController arcCtrl;
    Temperature_Info uartProvider;
    Mp3Controller mp3Ctrl;

    engine.rootContext()->setContextProperty("mp3Ctrl", &mp3Ctrl);
    engine.rootContext()->setContextProperty("uartProvider", &uartProvider);
    engine.rootContext()->setContextProperty("arcCtrl", &arcCtrl);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    // -------------------------------------------------
    // D-Bus listener: lắng nghe dữ liệu từ cổng USB sau đó đưa dữ liệu nhận được cho QML để hiển thị tới người dùng
    // -------------------------------------------------
    VehicleListener listener;
    listener.init();

    QObject::connect(&listener, &VehicleListener::newData, [&](QString value){
        uartProvider.setUartText(value);

        QStringList parts = value.split("@"); // cắt dữ liệu. vì dữ liệu có dạng speed@rpm@celcius@
        if(parts.size() == 3) {
            int speed = parts.at(1).toInt();
            int newAngle = static_cast<int>(speed * 0.78125);
            arcCtrl.setSpanAngle(newAngle);
        }
    });

    return app.exec();
}
