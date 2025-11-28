# GET /cards/:id

Xem chi tiết một card (Public endpoint).

## Endpoint

```
GET /api/v1/cards/:id
```

## Authentication

❌ Không yêu cầu authentication (Public)

## Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | ✅ Yes | Card ID (MongoDB ObjectId) |

## Response

### Success Response (200 OK)

```json
{
  "_id": "507f1f77bcf86cd799439015",
  "userId": "507f1f77bcf86cd799439011",
  "cardName": "My Business Card",
  "ownerName": "John Doe",
  "email": "john@example.com",
  "phoneNumber": "+84 123 456 789",
  "company": "Tech Corp",
  "address": "123 Main St, Ho Chi Minh City",
  "description": "Senior Software Engineer",
  "avatarUrl": "https://example.com/avatar.jpg",
  "coverImageUrl": "https://example.com/cover.jpg",
  "theme": {
    "color": "#0ea5e9",
    "icon": "briefcase"
  },
  "links": [
    {
      "title": "Website",
      "url": "https://johndoe.com",
      "icon": "globe"
    }
  ],
  "qrCodeUrl": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
  "isActive": true,
  "viewCount": 151,
  "createdAt": "2025-11-28T10:00:00.000Z",
  "updatedAt": "2025-11-28T10:00:00.000Z"
}
```

**Note**: viewCount sẽ tự động tăng lên mỗi lần endpoint này được gọi (trừ khi là chủ card)

### Error Responses

#### 404 Not Found

```json
{
  "statusCode": 404,
  "message": "Card not found",
  "error": "Not Found"
}
```

## Example

### cURL

```bash
curl -X GET http://localhost:8080/api/v1/cards/507f1f77bcf86cd799439015
```

### JavaScript (Fetch)

```javascript
const cardId = '507f1f77bcf86cd799439015';

const response = await fetch(`http://localhost:8080/api/v1/cards/${cardId}`, {
  method: 'GET',
});

const card = await response.json();
console.log('Card details:', card);
```

### Python (requests)

```python
import requests

card_id = "507f1f77bcf86cd799439015"
url = f"http://localhost:8080/api/v1/cards/{card_id}"

response = requests.get(url)
card = response.json()
```

## Notes

- Đây là public endpoint - không cần authentication
- viewCount tự động tăng khi có người xem
- Nếu người xem là chủ card (có JWT token), viewCount không tăng
- Endpoint này được dùng khi scan QR code
