#ifndef UARTDATAPROVIDER_H
#define UARTDATAPROVIDER_H

#pragma once
#include <QObject>
#include <QString>

class UartDataProvider : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uartText READ uartText NOTIFY uartTextChanged)

public:
    explicit UartDataProvider(QObject *parent = nullptr) : QObject(parent) {}

    QString uartText() const { return m_uartText; }

    void setUartText(const QString &text) {
        if (m_uartText != text) {
            m_uartText = text;
            emit uartTextChanged();
        }
    }

signals:
    void uartTextChanged();

private:
    QString m_uartText;
};

#endif // UARTDATAPROVIDER_H
