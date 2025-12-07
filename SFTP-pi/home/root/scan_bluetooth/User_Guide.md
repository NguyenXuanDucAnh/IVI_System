# Chạy service trước và kết nối thiết bị host tới.
# Có thể dùng CLI hoặc dùng D-Bus

## Nếu dùng CLI: 

## Nếu dùng D-Bus thì ta gọi các service sau bên terminal hoặc QT. Các D-Bus service:
### Play
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.Play

### Pause
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.Pause

### Toggle Play/Pause
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.PlayPause

### Next track
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.Next

### Previous track
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.Previous

### Set volume to 0.5 (50%)
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.SetVolume double:0.5

### Volume up
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.VolumeUp

### Volume down
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.VolumeDown

### Get current volume
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.GetVolume

### Get metadata: lấy ra chuỗi gồm Title, Artist và Album
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.GetMetadata

### Get player status
dbus-send --session --print-reply --dest=com.example.BluetoothAudio \
  /com/example/BluetoothAudio com.example.BluetoothAudio.GetStatus