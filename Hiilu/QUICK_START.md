# Quick Start - Copy Assets

## Cách 1: Sử dụng script tự động (Nhanh nhất) ⚡

### Bước 1: Chạy script

```bash
cd Hiilu/scripts
./copy-assets.sh
```

Hoặc:

```bash
cd Hiilu/scripts
./setup-assets.sh
```

### Bước 2: Thêm vào Xcode

Sau khi script chạy xong, bạn có 2 cách:

**Cách A: Drag & Drop (Nhanh nhất)**

1. Mở Finder và navigate đến `Hiilu/Hiilu/Assets.xcassets/`
2. Mở Xcode project
3. Mở `Assets.xcassets` trong Project Navigator
4. Drag tất cả các folder `.imageset` từ Finder vào `Assets.xcassets` trong Xcode

**Cách B: Add Files**

1. Trong Xcode, right-click vào `Assets.xcassets`
2. Chọn "Add Files to Hiilu..."
3. Navigate đến `Hiilu/Hiilu/Assets.xcassets/`
4. Select tất cả các folder `.imageset`
5. Đảm bảo "Create groups" được chọn
6. Click "Add"

## Cách 2: Copy thủ công

Xem file `SETUP_ASSETS.md` để biết hướng dẫn chi tiết.

## Kiểm tra

Sau khi thêm assets:

1. Build project (⌘B)
2. Kiểm tra không có warnings về missing images
3. Chạy app và xem landing page hiển thị đúng

## Troubleshooting

### Script không chạy được

```bash
# Thêm quyền execute
chmod +x Hiilu/scripts/*.sh

# Chạy lại
cd Hiilu/scripts
./copy-assets.sh
```

### Assets không hiển thị trong Xcode

- Đảm bảo đã drag vào đúng `Assets.xcassets` (không phải folder khác)
- Kiểm tra tên image set khớp với tên trong code
- Clean build folder (⌘ShiftK) và build lại

### Một số images bị thiếu

- Kiểm tra file có tồn tại trong `frontend/public/assets/web/`
- Chạy lại script để copy các file còn thiếu
