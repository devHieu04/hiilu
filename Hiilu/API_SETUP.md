# API Setup cho iOS App

## Vấn đề với localhost trên iOS

Trên iOS Simulator, `localhost` hoạt động bình thường. Nhưng trên **real device**, bạn cần sử dụng IP address của máy Mac chạy backend.

## Cách setup

### 1. Tìm IP address của Mac

```bash
# Trên Mac, chạy lệnh:
ifconfig | grep "inet " | grep -v 127.0.0.1
```

Hoặc vào System Preferences → Network để xem IP address.

### 2. Cập nhật APIConfig.swift

Mở `Hiilu/Hiilu/Constants/APIConfig.swift` và thay đổi:

```swift
#if targetEnvironment(simulator)
static let baseURL = "http://localhost:8080/api/v1"
#else
// Thay YOUR_MAC_IP bằng IP thực của Mac
static let baseURL = "http://YOUR_MAC_IP:8080/api/v1"
#endif
```

Ví dụ:
```swift
static let baseURL = "http://192.168.1.100:8080/api/v1"
```

### 3. Đảm bảo backend đang chạy

```bash
cd backend
npm run start:dev
```

### 4. Kiểm tra kết nối

- Backend phải chạy trên port 8080
- Mac và iPhone phải cùng mạng WiFi
- Firewall không block port 8080

## Troubleshooting

### Lỗi "Publishing changes from background threads"

Đã được fix trong `AuthManager.swift` - tất cả `@Published` updates đều trên `MainActor`.

### Lỗi NaN trong CoreGraphics

Đã được fix bằng cách:
- Kiểm tra image tồn tại trước khi sử dụng
- Sử dụng fallback images nếu không tìm thấy
- Đảm bảo tất cả frame sizes đều có giá trị hợp lệ

### Network errors

- Kiểm tra backend đang chạy
- Kiểm tra IP address đúng
- Kiểm tra cùng mạng WiFi
- Thử ping từ iPhone đến Mac IP
