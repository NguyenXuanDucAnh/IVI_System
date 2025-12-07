# File này nói về kiến thức chung khi phát triển dự án
# Kiến thức về QT
### 1. Từ khóa explicit: dùng để ngăn constructor bị gọi thông qua ép kiểu ngầm định, giúp code an toàn và rõ ràng hơn.
### 2. Argument khi khái bao constructor:
#### QObject* parent = nullptr: giúp Qt tự quản lý bộ nhớ, tự hủy object con, tự ngắt signal/slot, đồng thời vẫn cho phép object hoạt động độc lập khi không có cha.
Ví dụ: Đây cũng là format chung khi khai báo constructor trong QT
```C++
class VehicleListener : public QObject
{
    Q_OBJECT
public:
    explicit VehicleListener(QObject* parent = nullptr); // constructor
    void init();

signals: // tín hiệu được phát ra khi có một function nào đó được hoàn thành và chương trình muốn trace (tracking) nó
    void newData(QString value);

public slots:
    void onDataUpdated(QString value); // tương tự như phương thức (method) hoặc một hàm (function)
};
```

# Kiến thức về Python

# Kiến thức về System (hệ thống trong Raspberry pi)