#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QLocalSocket>
#include <QTimer>
#include <QDebug>
#include <QQmlContext>

#include "UartDataProvider.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // --- Tạo object để truyền dữ liệu UART ---
    UartDataProvider uartProvider;
    engine.rootContext()->setContextProperty("uartProvider", &uartProvider);

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
    });

    return app.exec();
}
