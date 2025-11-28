# POST /cards/:id/regenerate-qr

Tạo lại QR code cho card.

## Endpoint

```
POST /api/v1/cards/:id/regenerate-qr
```

## Authentication

✅ Yêu cầu authentication

## Headers

| Header | Value | Required |
|--------|-------|----------|
| Authorization | Bearer {token} | ✅ Yes |

## Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | ✅ Yes | Card ID |

## Request Body

Không yêu cầu body

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
  "qrCodeUrl": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
  "isActive": true,
  "viewCount": 150,
  "createdAt": "2025-11-28T10:00:00.000Z",
  "updatedAt": "2025-11-28T11:35:00.000Z"
}
```

### Error Responses

#### 401 Unauthorized

```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Unauthorized"
}
```

#### 403 Forbidden - Not Card Owner

```json
{
  "statusCode": 403,
  "message": "You do not have permission to update this card",
  "error": "Forbidden"
}
```

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
curl -X POST http://localhost:8080/api/v1/cards/507f1f77bcf86cd799439015/regenerate-qr \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### JavaScript (Fetch)

```javascript
const token = localStorage.getItem('token');
const cardId = '507f1f77bcf86cd799439015';

const response = await fetch(
  `http://localhost:8080/api/v1/cards/${cardId}/regenerate-qr`,
  {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
    },
  }
);

const card = await response.json();
console.log('New QR Code:', card.qrCodeUrl);
```

### Python (requests)

```python
import requests

token = "your_jwt_token_here"
card_id = "507f1f77bcf86cd799439015"
url = f"http://localhost:8080/api/v1/cards/{card_id}/regenerate-qr"
headers = {"Authorization": f"Bearer {token}"}

response = requests.post(url, headers=headers)
card = response.json()
print(f"New QR Code generated: {len(card['qrCodeUrl'])} bytes")
```

## Notes

- QR code được generate lại với cùng URL: `{APP_URL}/card/{cardId}`
- QR code format: Data URL (base64 encoded PNG)
- QR code có error correction level 'H' (high)
- QR code size: 512x512 pixels
- Có thể cần regenerate nếu:
  - QR code bị lỗi
  - Muốn QR code mới với format khác
  - Cần refresh QR code image
