# Role-Based Access Control (RBAC)

## Overview

HiiLu API sử dụng role-based access control để phân quyền users.

## Roles

### User Roles

| Role | Description |
|------|-------------|
| `admin` | Quản trị viên - Có quyền truy cập tất cả resources |
| `user` | Người dùng thường - Quyền truy cập limited |

## Role Assignment

### First User is Admin

User đầu tiên đăng ký trong hệ thống sẽ **tự động được gán role `admin`**.

```javascript
// First user registration
POST /api/v1/auth/register
{
  "email": "admin@example.com",
  "name": "Admin User",
  "password": "password123"
}

// Response
{
  "user": {
    "_id": "...",
    "email": "admin@example.com",
    "name": "Admin User",
    "role": "admin",  // <- Automatically assigned
    ...
  },
  "token": "..."
}
```

### Subsequent Users

Tất cả users đăng ký sau đó sẽ có role `user` mặc định.

```javascript
// Second user registration
POST /api/v1/auth/register
{
  "email": "john@example.com",
  "name": "John Doe",
  "password": "password123"
}

// Response
{
  "user": {
    "_id": "...",
    "email": "john@example.com",
    "name": "John Doe",
    "role": "user",  // <- Default role
    ...
  },
  "token": "..."
}
```

## Protected Endpoints

### Admin Only Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/v1/auth/users | Lấy danh sách tất cả users |

### User Endpoints (Auth Required)

Tất cả authenticated users (cả admin và user) có thể truy cập:

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/v1/auth/logout | Đăng xuất |
| GET | /api/v1/auth/me | Thông tin user hiện tại |
| GET | /api/v1/auth/login-history | Lịch sử đăng nhập |
| POST | /api/v1/cards | Tạo card |
| GET | /api/v1/cards | Danh sách cards của user |
| PATCH | /api/v1/cards/:id | Cập nhật card |
| DELETE | /api/v1/cards/:id | Xóa card |

## Implementation

### Using Roles Decorator

Để protect một endpoint chỉ cho admin:

```typescript
import { UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { RolesGuard } from './guards/roles.guard';
import { Roles } from './decorators/roles.decorator';
import { UserRole } from './schemas/user.schema';

@Get('admin-only')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.ADMIN)
async adminOnlyEndpoint() {
  return { message: 'Admin only access' };
}
```

### Multiple Roles

Có thể allow nhiều roles:

```typescript
@Roles(UserRole.ADMIN, UserRole.USER)
```

## Checking User Role

### In JWT Token

Role của user được include trong response sau khi login/register:

```json
{
  "user": {
    "_id": "...",
    "email": "user@example.com",
    "name": "User Name",
    "role": "user",  // <- Role here
    ...
  },
  "token": "..."
}
```

### Via /auth/me Endpoint

```bash
curl -X GET http://localhost:8080/api/v1/auth/me \
  -H "Authorization: Bearer {token}"

# Response
{
  "_id": "...",
  "email": "user@example.com",
  "name": "User Name",
  "role": "user",  // <- Check role
  ...
}
```

## Frontend Implementation

### Role-based UI

```javascript
// Check if user is admin
const user = await fetch('/api/v1/auth/me', {
  headers: { 'Authorization': `Bearer ${token}` }
}).then(r => r.json());

if (user.role === 'admin') {
  // Show admin UI
  showAdminPanel();
} else {
  // Show regular user UI
  showUserPanel();
}
```

### Protecting Routes

```javascript
// React example
import { Navigate } from 'react-router-dom';

function AdminRoute({ children }) {
  const user = useUser();

  if (user.role !== 'admin') {
    return <Navigate to="/" />;
  }

  return children;
}
```

## Error Responses

### 403 Forbidden

Khi user không có quyền truy cập:

```json
{
  "statusCode": 403,
  "message": "Forbidden resource",
  "error": "Forbidden"
}
```

## Best Practices

1. **Always check role on backend** - Never trust frontend role checks alone
2. **Use role guards** - Apply both JwtAuthGuard and RolesGuard for protected endpoints
3. **Verify first user** - Make sure the first registered user is the intended admin
4. **Log admin actions** - Track all admin operations for security
5. **Principle of least privilege** - Only grant minimum required permissions

## Database Schema

```typescript
{
  email: string,
  name: string,
  password: string,
  role: 'admin' | 'user',  // <- Role enum
  isActive: boolean,
  createdAt: Date,
  updatedAt: Date
}
```

## Notes

- User role không thể thay đổi qua API (cần database access)
- Admin có thể thực hiện tất cả actions của user
- Hệ thống chỉ support 2 roles: admin và user
- Future: Có thể mở rộng thêm roles như 'moderator', 'premium_user', etc.
