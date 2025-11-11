#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QLocalSocket>
#include <QTimer>
#include <QDebug>
#include <QQmlContext>

#include "UartDataProvider.h"
#include "arccontroller.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ArcController arcCtrl;
    // --- Tạo object để truyền dữ liệu UART ---
    // UartDataProvider uartProvider;
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

    // --- Kết nối socket UART ---
    QLocalSocket socket;
    socket.connectToServer("/tmp/uart_socket");

    if (!socket.waitForConnected(3000)) {
        qWarning() << "Cannot connect to UART socket";
        return -1;
    }

    QObject::connect(&socket, &QLocalSocket::readyRead, [&]() {
        QByteArray data = socket.readAll();
        QString str = QString::fromUtf8(data);
        qDebug() << "UART data:" << str;

        // --- Cập nhật dữ liệu cho QML ---
        uartProvider.setUartText(str);

        // --- Cập nhật dữ liệu cho Kim chỉ tốc độ ---
        QString main_speed_info_string = uartProvider.speed_info();
        int  main_speed_info_int = main_speed_info_string.toInt();
        int newAngle = (int)((main_speed_info_int*0.8125));

        arcCtrl.setSpanAngle(newAngle);

        qDebug() << "main_speed_info:" << newAngle;

    });   

    return app.exec();
}
