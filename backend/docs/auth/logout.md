# POST /auth/logout

Đăng xuất khỏi hệ thống.

## Endpoint

```
POST /api/v1/auth/logout
```

## Authentication

✅ Yêu cầu authentication

## Headers

| Header | Value | Required |
|--------|-------|----------|
| Content-Type | application/json | ✅ Yes |
| Authorization | Bearer {token} | ✅ Yes |

## Request Body

Không yêu cầu body

## Response

### Success Response (200 OK)

```json
{
  "message": "Logged out successfully"
}
```

### Error Responses

#### 401 Unauthorized - Missing or Invalid Token

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
curl -X POST http://localhost:8080/api/v1/auth/logout \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### JavaScript (Fetch)

```javascript
const token = localStorage.getItem('token');

const response = await fetch('http://localhost:8080/api/v1/auth/logout', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  },
});

const data = await response.json();

// Xóa token khỏi storage
localStorage.removeItem('token');
```

## Notes

- JWT là stateless nên logout chủ yếu xử lý ở client-side bằng cách xóa token
- Endpoint này được tạo để có thể log logout action nếu cần
- Client nên xóa token sau khi logout thành công
