# POST /auth/register

Đăng ký tài khoản mới.

## Endpoint

```
POST /api/v1/auth/register
```

## Authentication

❌ Không yêu cầu authentication

## Headers

| Header | Value | Required |
|--------|-------|----------|
| Content-Type | application/json | ✅ Yes |

## Request Body

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| email | string | ✅ Yes | Valid email format | Email của người dùng |
| name | string | ✅ Yes | Min 2 characters | Tên người dùng |
| password | string | ✅ Yes | Min 6 characters | Mật khẩu |

### Example Request

```json
{
  "email": "john.doe@example.com",
  "name": "John Doe",
  "password": "SecurePassword123"
}
```

## Response

### Success Response (201 Created)

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

**Note**: Password không được trả về trong response

### Error Responses

#### 400 Bad Request - Validation Error

```json
{
  "statusCode": 400,
  "message": [
    "email must be an email",
    "name must be longer than or equal to 2 characters",
    "password must be longer than or equal to 6 characters"
  ],
  "error": "Bad Request"
}
```

#### 409 Conflict - Email Already Exists

```json
{
  "statusCode": 409,
  "message": "Email already registered",
  "error": "Conflict"
}
```

## Example

### cURL

```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "name": "John Doe",
    "password": "SecurePassword123"
  }'
```

### JavaScript (Fetch)

```javascript
const response = await fetch('http://localhost:8080/api/v1/auth/register', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    email: 'john.doe@example.com',
    name: 'John Doe',
    password: 'SecurePassword123',
  }),
});

const data = await response.json();
console.log(data);
```

### Python (requests)

```python
import requests

url = "http://localhost:8080/api/v1/auth/register"
payload = {
    "email": "john.doe@example.com",
    "name": "John Doe",
    "password": "SecurePassword123"
}

response = requests.post(url, json=payload)
print(response.json())
```

## Notes

- Mật khẩu sẽ được hash tự động trước khi lưu vào database (sử dụng bcrypt)
- Email sẽ được convert sang lowercase và trim spaces
- Sau khi đăng ký thành công, token JWT được trả về để sử dụng cho các request tiếp theo
- Token có thời hạn 7 ngày
