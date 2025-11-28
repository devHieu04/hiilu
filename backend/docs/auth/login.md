# POST /auth/login

Đăng nhập vào hệ thống.

## Endpoint

```
POST /api/v1/auth/login
```

## Authentication

❌ Không yêu cầu authentication

## Headers

| Header | Value | Required | Description |
|--------|-------|----------|-------------|
| Content-Type | application/json | ✅ Yes | |
| x-platform | web / mobile_ios / mobile_android / desktop / tablet | ❌ No | Platform tracking (optional) |

## Request Body

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | string | ✅ Yes | Email đã đăng ký |
| password | string | ✅ Yes | Mật khẩu |

### Example Request

```json
{
  "email": "john.doe@example.com",
  "password": "SecurePassword123"
}
```

## Response

### Success Response (200 OK)

```json
{
  "user": {
    "_id": "507f1f77bcf86cd799439011",
    "email": "john.doe@example.com",
    "name": "John Doe",
    "isActive": true,
    "createdAt": "2025-11-28T10:00:00.000Z",
    "updatedAt": "2025-11-28T10:00:00.000Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Error Responses

#### 400 Bad Request - Validation Error

```json
{
  "statusCode": 400,
  "message": [
    "email must be an email",
    "password should not be empty"
  ],
  "error": "Bad Request"
}
```

#### 401 Unauthorized - Invalid Credentials

```json
{
  "statusCode": 401,
  "message": "Invalid credentials",
  "error": "Unauthorized"
}
```

#### 401 Unauthorized - Account Inactive

```json
{
  "statusCode": 401,
  "message": "Account is inactive",
  "error": "Unauthorized"
}
```

## Login History Tracking

Mỗi lần đăng nhập (thành công hoặc thất bại) sẽ được lưu vào database với thông tin:
- Platform (từ header `x-platform` hoặc auto-detect từ User-Agent)
- IP Address
- User Agent
- Timestamp
- Success/Failure status

## Example

### cURL

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -H "x-platform: web" \
  -d '{
    "email": "john.doe@example.com",
    "password": "SecurePassword123"
  }'
```

### JavaScript (Fetch)

```javascript
const response = await fetch('http://localhost:8080/api/v1/auth/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'x-platform': 'web',
  },
  body: JSON.stringify({
    email: 'john.doe@example.com',
    password: 'SecurePassword123',
  }),
});

const data = await response.json();
// Lưu token vào localStorage hoặc state management
localStorage.setItem('token', data.token);
```

### Python (requests)

```python
import requests

url = "http://localhost:8080/api/v1/auth/login"
headers = {
    "Content-Type": "application/json",
    "x-platform": "web"
}
payload = {
    "email": "john.doe@example.com",
    "password": "SecurePassword123"
}

response = requests.post(url, json=payload, headers=headers)
data = response.json()
token = data.get('token')
```

## Notes

- Token JWT được trả về có thời hạn 7 ngày
- Lưu token để sử dụng cho các request cần authentication
- Nên gửi header `x-platform` để tracking chính xác platform
- Login history sẽ tracking cả failed attempts để security monitoring
