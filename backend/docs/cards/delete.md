# DELETE /cards/:id

Xóa card (soft delete).

## Endpoint

```
DELETE /api/v1/cards/:id
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
  "message": "Card deleted successfully"
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
  "message": "You do not have permission to delete this card",
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
curl -X DELETE http://localhost:8080/api/v1/cards/507f1f77bcf86cd799439015 \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### JavaScript (Fetch)

```javascript
const token = localStorage.getItem('token');
const cardId = '507f1f77bcf86cd799439015';

const response = await fetch(`http://localhost:8080/api/v1/cards/${cardId}`, {
  method: 'DELETE',
  headers: {
    'Authorization': `Bearer ${token}`,
  },
});

const result = await response.json();
console.log(result.message);
```

### Python (requests)

```python
import requests

token = "your_jwt_token_here"
card_id = "507f1f77bcf86cd799439015"
url = f"http://localhost:8080/api/v1/cards/{card_id}"
headers = {"Authorization": f"Bearer {token}"}

response = requests.delete(url, headers=headers)
print(response.json())
```

## Notes

- Đây là soft delete - card không bị xóa khỏi database
- Card sẽ được đánh dấu `isActive = false`
- Card đã xóa sẽ không xuất hiện trong danh sách cards
- Chỉ chủ card mới có quyền xóa
- Có thể restore card bằng cách set lại `isActive = true` (qua database hoặc admin panel)
