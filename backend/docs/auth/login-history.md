# GET /auth/login-history

Lấy lịch sử đăng nhập của user.

## Endpoint

```
GET /api/v1/auth/login-history
```

## Authentication

✅ Yêu cầu authentication

## Headers

| Header | Value | Required |
|--------|-------|----------|
| Authorization | Bearer {token} | ✅ Yes |

## Query Parameters

Không có (mặc định trả về 10 records gần nhất)

## Response

### Success Response (200 OK)

```json
[
  {
    "_id": "507f1f77bcf86cd799439012",
    "userId": "507f1f77bcf86cd799439011",
    "platform": "web",
    "ipAddress": "192.168.1.100",
    "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)...",
    "deviceInfo": null,
    "location": null,
    "isSuccessful": true,
    "failureReason": null,
    "createdAt": "2025-11-28T10:30:00.000Z"
  },
  {
    "_id": "507f1f77bcf86cd799439013",
    "userId": "507f1f77bcf86cd799439011",
    "platform": "mobile_ios",
    "ipAddress": "192.168.1.101",
    "userAgent": "HiiLu/1.0 CFNetwork/1410.0.3 Darwin/22.6.0",
    "deviceInfo": null,
    "location": null,
    "isSuccessful": true,
    "failureReason": null,
    "createdAt": "2025-11-28T09:15:00.000Z"
  },
  {
    "_id": "507f1f77bcf86cd799439014",
    "userId": "507f1f77bcf86cd799439011",
    "platform": "web",
    "ipAddress": "192.168.1.100",
    "userAgent": "Mozilla/5.0...",
    "deviceInfo": null,
    "location": null,
    "isSuccessful": false,
    "failureReason": "Invalid password",
    "createdAt": "2025-11-28T08:00:00.000Z"
  }
]
```

### Platform Values

| Value | Description |
|-------|-------------|
| `web` | Web browser |
| `mobile_ios` | iOS mobile app |
| `mobile_android` | Android mobile app |
| `tablet` | Tablet device |
| `desktop` | Desktop application |
| `unknown` | Không xác định được |

### Error Responses

#### 401 Unauthorized

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
curl -X GET http://localhost:8080/api/v1/auth/login-history \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### JavaScript (Fetch)

```javascript
const token = localStorage.getItem('token');

const response = await fetch('http://localhost:8080/api/v1/auth/login-history', {
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${token}`,
  },
});

const loginHistory = await response.json();
console.log(loginHistory);
```

### Python (requests)

```python
import requests

token = "your_jwt_token_here"
url = "http://localhost:8080/api/v1/auth/login-history"
headers = {"Authorization": f"Bearer {token}"}

response = requests.get(url, headers=headers)
history = response.json()

for login in history:
    print(f"Platform: {login['platform']}, Success: {login['isSuccessful']}")
```

## Notes

- Mặc định trả về 10 login attempts gần nhất
- Bao gồm cả successful và failed attempts
- Hữu ích cho security monitoring
- Có thể detect unauthorized access attempts
- Platform được detect tự động hoặc từ header `x-platform`
