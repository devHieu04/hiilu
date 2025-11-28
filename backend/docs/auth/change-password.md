# POST /auth/change-password

Thay đổi mật khẩu của user hiện tại.

## Endpoint

```
POST /api/v1/auth/change-password
```

## Authentication

✅ Yêu cầu authentication

## Headers

| Header | Value | Required |
|--------|-------|----------|
| Content-Type | application/json | ✅ Yes |
| Authorization | Bearer {token} | ✅ Yes |

## Request Body

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| currentPassword | string | ✅ Yes | Mật khẩu hiện tại (tối thiểu 6 ký tự) |
| newPassword | string | ✅ Yes | Mật khẩu mới (tối thiểu 6 ký tự, phải chứa chữ hoa, chữ thường và số) |
| confirmPassword | string | ✅ Yes | Xác nhận mật khẩu mới (phải giống newPassword) |

### Password Requirements

Mật khẩu mới phải:
- Tối thiểu 6 ký tự
- Chứa ít nhất 1 chữ cái viết hoa (A-Z)
- Chứa ít nhất 1 chữ cái viết thường (a-z)
- Chứa ít nhất 1 chữ số (0-9)

### Example Request

```json
{
  "currentPassword": "OldPassword123",
  "newPassword": "NewPassword456",
  "confirmPassword": "NewPassword456"
}
```

## Response

### Success Response (200 OK)

```json
{
  "message": "Password changed successfully"
}
```

### Error Responses

#### 400 Bad Request - Validation Error

```json
{
  "statusCode": 400,
  "message": [
    "New password must be at least 6 characters long",
    "New password must contain at least one uppercase letter, one lowercase letter, and one number"
  ],
  "error": "Bad Request"
}
```

#### 400 Bad Request - Passwords Don't Match

```json
{
  "statusCode": 400,
  "message": "New password and confirm password do not match",
  "error": "Bad Request"
}
```

#### 400 Bad Request - Same as Current Password

```json
{
  "statusCode": 400,
  "message": "New password must be different from current password",
  "error": "Bad Request"
}
```

#### 401 Unauthorized - Wrong Current Password

```json
{
  "statusCode": 401,
  "message": "Current password is incorrect",
  "error": "Unauthorized"
}
```

#### 401 Unauthorized - Not Logged In

```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Unauthorized"
}
```

## Example

### cURL

```bash
curl -X POST http://localhost:8080/api/v1/auth/change-password \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -d '{
    "currentPassword": "OldPassword123",
    "newPassword": "NewPassword456",
    "confirmPassword": "NewPassword456"
  }'
```

### JavaScript (Fetch)

```javascript
const token = localStorage.getItem('token');

const response = await fetch('http://localhost:8080/api/v1/auth/change-password', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  },
  body: JSON.stringify({
    currentPassword: 'OldPassword123',
    newPassword: 'NewPassword456',
    confirmPassword: 'NewPassword456',
  }),
});

const result = await response.json();

if (response.ok) {
  console.log('Password changed successfully');
  // Optionally logout and ask user to login again
} else {
  console.error('Error:', result.message);
}
```

### Python (requests)

```python
import requests

token = "your_jwt_token_here"
url = "http://localhost:8080/api/v1/auth/change-password"
headers = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {token}"
}
data = {
    "currentPassword": "OldPassword123",
    "newPassword": "NewPassword456",
    "confirmPassword": "NewPassword456"
}

response = requests.post(url, json=data, headers=headers)

if response.status_code == 200:
    print("Password changed successfully")
elif response.status_code == 401:
    print("Current password is incorrect")
elif response.status_code == 400:
    print(f"Error: {response.json()['message']}")
```

## Notes

- Phải nhập đúng mật khẩu hiện tại để thay đổi
- Mật khẩu mới và xác nhận mật khẩu phải giống nhau
- Mật khẩu mới phải khác mật khẩu hiện tại
- Mật khẩu mới sẽ được hash tự động trước khi lưu vào database
- **Best practice**: Sau khi đổi mật khẩu thành công, nên logout user và yêu cầu đăng nhập lại
- Token hiện tại vẫn hợp lệ sau khi đổi mật khẩu (JWT stateless)
