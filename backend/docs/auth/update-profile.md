# PATCH /auth/profile

Cập nhật thông tin profile của user hiện tại.

## Endpoint

```
PATCH /api/v1/auth/profile
```

## Authentication

✅ Yêu cầu authentication

## Headers

| Header | Value | Required |
|--------|-------|----------|
| Content-Type | application/json | ✅ Yes |
| Authorization | Bearer {token} | ✅ Yes |

## Request Body

Tất cả fields đều optional - chỉ gửi các fields cần update.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | string | ❌ No | Tên mới (tối thiểu 2 ký tự) |
| email | string | ❌ No | Email mới (phải là email hợp lệ) |

### Example Request

```json
{
  "name": "John Doe Updated",
  "email": "john.updated@example.com"
}
```

## Response

### Success Response (200 OK)

```json
{
  "_id": "507f1f77bcf86cd799439011",
  "email": "john.updated@example.com",
  "name": "John Doe Updated",
  "role": "user",
  "isActive": true,
  "createdAt": "2025-11-28T10:00:00.000Z",
  "updatedAt": "2025-11-28T15:30:00.000Z"
}
```

**Note**: Password không được trả về

### Error Responses

#### 400 Bad Request - Validation Error

```json
{
  "statusCode": 400,
  "message": [
    "Invalid email format",
    "Name must be at least 2 characters long"
  ],
  "error": "Bad Request"
}
```

#### 401 Unauthorized

```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Unauthorized"
}
```

#### 409 Conflict - Email Already in Use

```json
{
  "statusCode": 409,
  "message": "Email already in use",
  "error": "Conflict"
}
```

## Example

### cURL

```bash
curl -X PATCH http://localhost:8080/api/v1/auth/profile \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -d '{
    "name": "John Doe Updated",
    "email": "john.updated@example.com"
  }'
```

### JavaScript (Fetch)

```javascript
const token = localStorage.getItem('token');

const response = await fetch('http://localhost:8080/api/v1/auth/profile', {
  method: 'PATCH',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  },
  body: JSON.stringify({
    name: 'John Doe Updated',
    email: 'john.updated@example.com',
  }),
});

const updatedUser = await response.json();
console.log('Updated profile:', updatedUser);
```

### Python (requests)

```python
import requests

token = "your_jwt_token_here"
url = "http://localhost:8080/api/v1/auth/profile"
headers = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {token}"
}
data = {
    "name": "John Doe Updated",
    "email": "john.updated@example.com"
}

response = requests.patch(url, json=data, headers=headers)

if response.status_code == 200:
    user = response.json()
    print(f"Profile updated: {user['name']}")
elif response.status_code == 409:
    print("Email already in use")
```

## Notes

- Chỉ user hiện tại mới có thể cập nhật profile của mình
- Có thể update một hoặc nhiều fields
- Email mới phải chưa được sử dụng bởi user khác
- updatedAt sẽ tự động được cập nhật
- Không thể update password qua endpoint này (sử dụng [POST /auth/change-password](./change-password.md))
