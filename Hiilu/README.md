# Hiilu iOS App

Ứng dụng iOS cho nền tảng HiiLu - Tạo và chia sẻ thẻ cá nhân thông minh.

## Cấu trúc thư mục

```
Hiilu/
├── Hiilu/
│   ├── Constants/          # Constants và configuration
│   │   ├── APIConfig.swift
│   │   └── APIEndpoints.swift
│   ├── Models/             # Data models
│   │   ├── Card.swift
│   │   └── User.swift
│   ├── Services/           # API services
│   │   └── APIService.swift
│   ├── Views/              # SwiftUI views
│   │   └── LandingPageView.swift
│   ├── Assets.xcassets/    # Images và assets
│   └── ContentView.swift
```

## Setup Assets

### ⚡ Cách nhanh nhất: Sử dụng script tự động

```bash
cd Hiilu/scripts
./copy-assets.sh
```

Script sẽ tự động:

- Copy tất cả images từ `frontend/public/assets/web/`
- Tạo cấu trúc `.imageset` folders
- Tạo `Contents.json` cho mỗi image set

Sau đó chỉ cần drag & drop các `.imageset` folders vào Xcode!

Xem chi tiết trong [QUICK_START.md](QUICK_START.md)

### 📋 Các assets sẽ được copy:

- `Group 4.png` - Logo
- `Group 69.png` - Hero image
- `image3.png`, `image4.png` - About images
- `antenna.png`, `link.png`, `brand (2).png` - Feature icons
- `color-palette.png`, `user-profile-01.png`, `id-card.png` - Feature icons
- `chat (3).png`, `link-angled.png`, `personalized-support.png` - Feature icons

### 🔧 Cách thêm vào Xcode (sau khi chạy script):

**Cách 1: Drag & Drop (Nhanh nhất)**

1. Mở Finder → `Hiilu/Hiilu/Assets.xcassets/`
2. Mở Xcode → `Assets.xcassets` trong Project Navigator
3. Drag tất cả `.imageset` folders từ Finder vào Xcode

**Cách 2: Add Files**

1. Right-click `Assets.xcassets` trong Xcode
2. Chọn "Add Files to Hiilu..."
3. Select tất cả `.imageset` folders
4. Click "Add"

Xem hướng dẫn chi tiết trong [SETUP_ASSETS.md](SETUP_ASSETS.md)

## API Configuration

### Development

Mặc định API base URL là `http://localhost:8080/api/v1`

### Production

Để thay đổi sang production URL, sửa trong `APIConfig.swift`:

```swift
static let baseURL = "https://api.hiilu.com/api/v1"
```

## Các tính năng đã implement

### ✅ Landing Page

- Hero section với logo, title, description
- Highlight features carousel
- About section
- Features section
- Contact section
- Login/Register buttons (placeholder views)

### ✅ API Setup

- API endpoints constants
- API configuration
- API service với authentication
- Models cho Card và User

## Các tính năng cần implement tiếp

- [ ] Login/Register views
- [ ] Dashboard view
- [ ] Card creation/editing
- [ ] Card list view
- [ ] Card detail view
- [ ] QR code generation
- [ ] Share functionality
- [ ] User profile
- [ ] Authentication state management

## Development

1. Mở project trong Xcode
2. Chọn target device (iPhone simulator hoặc real device)
3. Build và run (⌘R)

## Notes

- App sử dụng SwiftUI
- API service sử dụng async/await
- Models sử dụng Codable để decode JSON
- Tất cả API endpoints được định nghĩa trong `APIEndpoints.swift`
