#ifndef UARTDATAPROVIDER_H
#define UARTDATAPROVIDER_H

#pragma once
#include <QObject>
#include <QString>
#include <string.h>

#include <QDebug>

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

protected:
    QString m_uartText;
};

class Temperature_Info : public UartDataProvider
{
    Q_OBJECT
    Q_PROPERTY(QString Temperature_oil_info READ Temperature_oil_info NOTIFY uartTextChanged)
    Q_PROPERTY(QString speed_info READ speed_info NOTIFY uartTextChanged)
    Q_PROPERTY(QString rpm_info READ rpm_info NOTIFY uartTextChanged)

    public:
        QString Temperature_oil_info()
        {
            QString temperature;
            int index = 0;

            while (index < m_uartText.size() && m_uartText[index] != '@')
            {
                temperature.append(m_uartText[index]);   // ✅ thêm ký tự vào cuối chuỗi
//                qDebug() << "UART data debug:" << m_uartText[index];
                index++;
            }
            return temperature;
        }

       QString speed_info()
       {
           QString speed_info_text;
           int index = 0;
           int start_index_info = 0;

           int count_char = 0;


           while (index < m_uartText.size() && count_char < 2)
           {
                index++;
                if (m_uartText[index] == '@')
                {
                    count_char++;
                }  
                else if (m_uartText[index] != '@' && count_char > 0)
                {
                    speed_info_text.append(m_uartText[index]);
                }
           }
           return speed_info_text;
       }

       QString rpm_info()
       {
           QString rpm_info_text;
           int index = 0;
           int start_index_info = 0;

           int count_char = 0;


           while (index < m_uartText.size() && count_char < 3)
           {
                index++;
                if (m_uartText[index] == '@')
                {
                    count_char++;
                }  
                else if (m_uartText[index] == '\r')
                {
                    break;
                }
                else if (m_uartText[index] != '@' && count_char > 1)
                {
                    rpm_info_text.append(m_uartText[index]);
                }
                
           }
           return rpm_info_text;
       }
};


#endif // UARTDATAPROVIDER_H 
