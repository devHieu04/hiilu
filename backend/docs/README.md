# HiiLu API Documentation

## Overview

HiiLu API cung cấp các endpoint để quản lý tài khoản người dùng và smart cards (thẻ thông minh).

**Base URL**: `http://localhost:8080/api/v1`

**Environment**: Development

---

## Authentication

API sử dụng JWT (JSON Web Tokens) để xác thực. Sau khi đăng nhập hoặc đăng ký thành công, bạn sẽ nhận được một token. Token này cần được gửi kèm trong header của các request cần xác thực.

### Headers

```
Authorization: Bearer <your_jwt_token>
Content-Type: application/json
```

### Platform Tracking

API tự động tracking platform của request thông qua:
- Custom header `x-platform`: `web`, `mobile_ios`, `mobile_android`, `desktop`, `tablet`
- Auto-detect từ User-Agent nếu không có custom header

---

## Available Endpoints

### Authentication
- [POST /auth/register](./auth/register.md) - Đăng ký tài khoản mới
- [POST /auth/login](./auth/login.md) - Đăng nhập
- [POST /auth/logout](./auth/logout.md) - Đăng xuất (requires auth)
- [GET /auth/me](./auth/me.md) - Lấy thông tin user hiện tại (requires auth)
- [PATCH /auth/profile](./auth/update-profile.md) - Cập nhật thông tin profile (requires auth)
- [POST /auth/change-password](./auth/change-password.md) - Đổi mật khẩu (requires auth)
- [GET /auth/login-history](./auth/login-history.md) - Lịch sử đăng nhập (requires auth)
- [GET /auth/users](./auth/get-all-users.md) - Lấy danh sách tất cả users (admin only)

### Cards
- [POST /cards](./cards/create.md) - Tạo card mới (requires auth)
- [GET /cards](./cards/list.md) - Lấy danh sách cards (requires auth)
- [GET /cards/:id](./cards/get.md) - Xem chi tiết card (public)
- [PATCH /cards/:id](./cards/update.md) - Cập nhật card (requires auth)
- [DELETE /cards/:id](./cards/delete.md) - Xóa card (requires auth)
- [POST /cards/:id/regenerate-qr](./cards/regenerate-qr.md) - Tạo lại QR code (requires auth)

---

## Response Format

### Success Response

```json
{
  "data": {},
  "message": "Success message",
  "success": true
}
```

### Error Response

```json
{
  "statusCode": 400,
  "message": "Error message" | ["Error 1", "Error 2"],
  "error": "Bad Request"
}
```

---

## HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | OK - Request thành công |
| 201 | Created - Tạo resource thành công |
| 400 | Bad Request - Request không hợp lệ |
| 401 | Unauthorized - Chưa xác thực hoặc token không hợp lệ |
| 403 | Forbidden - Không có quyền truy cập |
| 404 | Not Found - Resource không tồn tại |
| 409 | Conflict - Conflict với resource hiện có (VD: email đã tồn tại) |
| 500 | Internal Server Error - Lỗi server |

---

## Getting Started

### 1. Đăng ký tài khoản

```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "name": "John Doe",
    "password": "password123"
  }'
```

### 2. Đăng nhập

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -H "x-platform: web" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### 3. Sử dụng token để tạo card

```bash
curl -X POST http://localhost:8080/api/v1/cards \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_token>" \
  -d '{
    "cardName": "My Business Card",
    "ownerName": "John Doe",
    "email": "john@example.com",
    "phoneNumber": "+84 123 456 789"
  }'
```

---

## Database Models

### User
```typescript
{
  _id: ObjectId,
  email: string,
  name: string,
  password: string (hashed),
  role: 'admin' | 'user',
  isActive: boolean,
  createdAt: Date,
  updatedAt: Date
}
```

**Note**: User đầu tiên đăng ký sẽ tự động được gán role `admin`. Xem [ROLES.md](./ROLES.md) để biết thêm chi tiết về role-based access control.

### Card
```typescript
{
  _id: ObjectId,
  userId: ObjectId,
  cardName: string,
  ownerName: string,
  avatarUrl?: string,
  coverImageUrl?: string,
  theme: {
    color: string,
    icon?: string
  },
  links: [{
    title: string,
    url: string,
    icon?: string
  }],
  address?: string,
  company?: string,
  description?: string,
  phoneNumber?: string,
  email?: string,
  qrCodeUrl?: string,
  isActive: boolean,
  viewCount: number,
  createdAt: Date,
  updatedAt: Date
}
```

### LoginHistory
```typescript
{
  _id: ObjectId,
  userId: ObjectId,
  platform: 'web' | 'mobile_ios' | 'mobile_android' | 'tablet' | 'desktop' | 'unknown',
  ipAddress: string,
  userAgent: string,
  deviceInfo?: string,
  location?: string,
  isSuccessful: boolean,
  failureReason?: string,
  createdAt: Date
}
```

---

## Support

Nếu có vấn đề hoặc câu hỏi, vui lòng liên hệ development team.
