
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

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ArcController arcCtrl;
    Temperature_Info uartProvider;

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
    // D-Bus listener
    // -------------------------------------------------
    VehicleListener listener;
    listener.init();

    QObject::connect(&listener, &VehicleListener::newData, [&](QString value){
        uartProvider.setUartText(value);

        QStringList parts = value.split("@");
        if(parts.size() == 3) {
            int speed = parts.at(1).toInt();
            int newAngle = static_cast<int>(speed * 0.78125);
            arcCtrl.setSpanAngle(newAngle);
//            qDebug() << "Speed angle =" << newAngle;
        }
    });

    return app.exec();
}
