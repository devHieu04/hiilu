# Scripts Directory

Các script tự động để setup và quản lý assets cho iOS app.

## copy-assets.sh

Script chính để copy assets từ web sang iOS app.

**Cách sử dụng:**

```bash
cd Hiilu/scripts
./copy-assets.sh
```

**Chức năng:**

- Tự động copy tất cả images từ `frontend/public/assets/web/`
- Tạo cấu trúc `.imageset` folders cho Xcode
- Tạo `Contents.json` cho mỗi image set
- Hiển thị progress và kết quả

**Output:**

- Tạo các folder `.imageset` trong `Hiilu/Hiilu/Assets.xcassets/`
- Mỗi folder chứa:
  - File PNG gốc
  - File `Contents.json` với cấu trúc Xcode

## setup-assets.sh

Script tương tự `copy-assets.sh`, có thể dùng thay thế.

## Troubleshooting

### Script không chạy được

```bash
# Thêm quyền execute
chmod +x copy-assets.sh setup-assets.sh
```

### Assets không tìm thấy

- Đảm bảo đang chạy script từ `Hiilu/scripts/` directory
- Kiểm tra đường dẫn `../../frontend/public/assets/web/` có đúng không

### Sau khi chạy script

1. Mở Xcode project
2. Drag & drop các `.imageset` folders vào `Assets.xcassets`
3. Build project để kiểm tra
