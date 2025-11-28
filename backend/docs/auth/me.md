# GET /auth/me

Lấy thông tin user hiện tại.

## Endpoint

```
GET /api/v1/auth/me
```

## Authentication

✅ Yêu cầu authentication

## Headers

| Header | Value | Required |
|--------|-------|----------|
| Authorization | Bearer {token} | ✅ Yes |

## Query Parameters

Không có

## Response

### Success Response (200 OK)

```json
{
  "_id": "507f1f77bcf86cd799439011",
  "email": "john.doe@example.com",
  "name": "John Doe",
  "isActive": true,
  "createdAt": "2025-11-28T10:00:00.000Z",
  "updatedAt": "2025-11-28T10:00:00.000Z"
}
```

**Note**: Password không được trả về

### Error Responses

#### 401 Unauthorized - Missing or Invalid Token

```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Unauthorized"
}
```

#### 401 Unauthorized - User Not Found or Inactive

```json
{
  "statusCode": 401,
  "message": "User not found or inactive",
  "error": "Unauthorized"
}
```

## Example

### cURL

```bash
curl -X GET http://localhost:8080/api/v1/auth/me \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### JavaScript (Fetch)

```javascript
const token = localStorage.getItem('token');

const response = await fetch('http://localhost:8080/api/v1/auth/me', {
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${token}`,
  },
});

const userData = await response.json();
console.log(userData);
```

### Python (requests)

```python
import requests

token = "your_jwt_token_here"
url = "http://localhost:8080/api/v1/auth/me"
headers = {"Authorization": f"Bearer {token}"}

response = requests.get(url, headers=headers)
user_data = response.json()
```

## Notes

- Endpoint này hữu ích để verify token còn hiệu lực
- Có thể dùng để lấy thông tin user sau khi page reload
- User data không bao gồm password
