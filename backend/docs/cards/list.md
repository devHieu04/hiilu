# GET /cards

Lấy danh sách tất cả cards của user hiện tại.

## Endpoint

```
GET /api/v1/cards
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
[
  {
    "_id": "507f1f77bcf86cd799439015",
    "userId": "507f1f77bcf86cd799439011",
    "cardName": "My Business Card",
    "ownerName": "John Doe",
    "email": "john@example.com",
    "phoneNumber": "+84 123 456 789",
    "company": "Tech Corp",
    "theme": {
      "color": "#0ea5e9"
    },
    "links": [],
    "qrCodeUrl": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
    "isActive": true,
    "viewCount": 150,
    "createdAt": "2025-11-28T10:00:00.000Z",
    "updatedAt": "2025-11-28T10:00:00.000Z"
  },
  {
    "_id": "507f1f77bcf86cd799439016",
    "userId": "507f1f77bcf86cd799439011",
    "cardName": "Personal Card",
    "ownerName": "John Doe",
    "email": "personal@example.com",
    "qrCodeUrl": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
    "isActive": true,
    "viewCount": 45,
    "createdAt": "2025-11-27T10:00:00.000Z",
    "updatedAt": "2025-11-27T10:00:00.000Z"
  }
]
```

**Note**: Chỉ trả về cards có `isActive = true`, được sắp xếp theo thời gian tạo mới nhất

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
curl -X GET http://localhost:8080/api/v1/cards \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### JavaScript (Fetch)

```javascript
const token = localStorage.getItem('token');

const response = await fetch('http://localhost:8080/api/v1/cards', {
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${token}`,
  },
});

const cards = await response.json();
console.log('My cards:', cards);
```

## Notes

- Chỉ trả về cards thuộc về user hiện tại
- Cards được sort theo createdAt giảm dần (mới nhất trước)
- Không trả về các cards đã bị soft-delete (isActive = false)
