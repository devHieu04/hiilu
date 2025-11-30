# Hướng dẫn Copy Assets từ Web sang iOS App

## Bước 1: Copy files

Copy các file PNG từ `frontend/public/assets/web/` sang thư mục tạm, sau đó thêm vào Xcode.

## Bước 2: Thêm vào Xcode Assets

### Cách 1: Drag & Drop trực tiếp

1. Mở Xcode project
2. Mở `Assets.xcassets` trong Project Navigator
3. Tạo Image Set mới:
   - Right-click vào `Assets.xcassets` → "New Image Set"
   - Đặt tên cho image set (ví dụ: "Group 4")
4. Drag file PNG vào image set
5. Lặp lại cho tất cả images

### Cách 2: Sử dụng Finder

1. Mở Finder và navigate đến `Hiilu/Hiilu/Assets.xcassets/`
2. Tạo folder mới cho mỗi image (ví dụ: `Group 4.imageset/`)
3. Copy file PNG vào folder đó
4. Tạo file `Contents.json` trong mỗi folder:

```json
{
  "images" : [
    {
      "filename" : "Group 4.png",
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

## Danh sách images cần thêm

| Image Name | File Name | Usage |
|------------|-----------|-------|
| Group 4 | Group 4.png | Logo |
| Group 69 | Group 69.png | Hero image |
| image3 | image3.png | About section |
| image4 | image4.png | About section |
| antenna | antenna.png | Feature icon |
| link | link.png | Feature icon |
| brand (2) | brand (2).png | Feature icon (đặt tên image set là "brand (2)") |
| color-palette | color-palette.png | Feature icon |
| user-profile-01 | user-profile-01.png | Feature icon |
| id-card | id-card.png | Feature icon |
| chat | chat (3).png | Feature icon (đặt tên image set là "chat") |
| link-angled | link-angled.png | Feature icon |
| personalized-support | personalized-support.png | Feature icon |

## Lưu ý

- Tên image set trong Xcode phải khớp chính xác với tên được sử dụng trong code
- Nếu tên file có khoảng trắng hoặc ký tự đặc biệt, có thể đặt tên image set khác với tên file
- Ví dụ: File `chat (3).png` có thể đặt tên image set là `chat` và sử dụng `Image("chat")` trong code
- File `brand (2).png` cần đặt tên image set là `brand (2)` để khớp với code

## Kiểm tra

Sau khi thêm assets, build project và kiểm tra:
- Không có warnings về missing images
- Images hiển thị đúng trong preview và simulator
