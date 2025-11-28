# GET /auth/users

Lấy danh sách tất cả users (Admin only).

## Endpoint

```
GET /api/v1/auth/users
```

## Authentication

✅ Yêu cầu authentication
🔐 Chỉ dành cho ADMIN

## Headers

| Header | Value | Required |
|--------|-------|----------|
| Authorization | Bearer {token} | ✅ Yes |

## Query Parameters

Không có

## Response

### Success Response (200 OK)

```json
[
  {
    "_id": "507f1f77bcf86cd799439011",
    "email": "admin@example.com",
    "name": "Admin User",
    "role": "admin",
    "isActive": true,
    "createdAt": "2025-11-28T10:00:00.000Z",
    "updatedAt": "2025-11-28T10:00:00.000Z"
  },
  {
    "_id": "507f1f77bcf86cd799439012",
    "email": "john.doe@example.com",
    "name": "John Doe",
    "role": "user",
    "isActive": true,
    "createdAt": "2025-11-28T11:00:00.000Z",
    "updatedAt": "2025-11-28T11:00:00.000Z"
  }
]
```

**Note**: Password không được trả về

### Error Responses

#### 401 Unauthorized

```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Unauthorized"
}
```

#### 403 Forbidden - Not Admin

```json
{
  "statusCode": 403,
  "message": "Forbidden resource",
  "error": "Forbidden"
}
```

## Example

### cURL

```bash
curl -X GET http://localhost:8080/api/v1/auth/users \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### JavaScript (Fetch)

```javascript
const token = localStorage.getItem('token');

const response = await fetch('http://localhost:8080/api/v1/auth/users', {
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${token}`,
  },
});

if (response.status === 403) {
  console.log('Access denied: Admin only');
} else {
  const users = await response.json();
  console.log('All users:', users);
}
```

### Python (requests)

```python
import requests

token = "your_admin_jwt_token_here"
url = "http://localhost:8080/api/v1/auth/users"
headers = {"Authorization": f"Bearer {token}"}

response = requests.get(url, headers=headers)

if response.status_code == 403:
    print("Access denied: Admin only")
else:
    users = response.json()
    for user in users:
        print(f"{user['name']} ({user['role']})")
```

## Notes

- Chỉ user có role 'admin' mới có thể truy cập endpoint này
- Users được sắp xếp theo thời gian tạo mới nhất
- Password không được trả về trong response
- User đầu tiên đăng ký sẽ tự động là admin
