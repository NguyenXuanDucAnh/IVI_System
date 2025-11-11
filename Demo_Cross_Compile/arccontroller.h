#ifndef ARCCONTROLLER_H
#define ARCCONTROLLER_H

// arccontroller.h
#include <QObject>

class ArcController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double spanAngle READ spanAngle WRITE setSpanAngle NOTIFY spanAngleChanged)

public:
    explicit ArcController(QObject *parent = nullptr) : QObject(parent), m_spanAngle(0) {}

    double spanAngle() const { return m_spanAngle; }
    void setSpanAngle(double angle) {
        if (qFuzzyCompare(m_spanAngle, angle))
            return;
        m_spanAngle = angle;
        emit spanAngleChanged();
    }

signals:
    void spanAngleChanged();

private:
    double m_spanAngle;
};


#endif // ARCCONTROLLER_H
