# Seed Scripts

## Seed Card UUIDs

Script này sẽ tự động tạo UUID cho tất cả các card cũ chưa có `shareUuid`.

### Cách chạy:

```bash
# Từ thư mục backend
npm run seed:card-uuids
```

### Chức năng:

- Tìm tất cả các card chưa có `shareUuid` (null, undefined, hoặc empty string)
- Tự động generate UUID cho mỗi card
- Hiển thị thông tin chi tiết về các card đã được cập nhật
- An toàn: Chỉ cập nhật các card chưa có UUID, không ảnh hưởng đến các card đã có UUID

### Output mẫu:

```
🔍 Đang tìm các card chưa có UUID...
📊 Tìm thấy 5 card(s) chưa có UUID
🔄 Đang cập nhật UUID cho các cards...
  ✓ Card 507f1f77bcf86cd799439015 - My Card: abc-123-def-456
  ✓ Card 507f1f77bcf86cd799439016 - Another Card: xyz-789-uvw-012
  ...

✅ Đã cập nhật UUID cho 5 card(s)!
🎉 Hoàn tất seed!
```

### Lưu ý:

- Script này chỉ cần chạy một lần để migrate các card cũ
- Các card mới được tạo sẽ tự động có UUID (đã được implement trong `cards.service.ts`)
