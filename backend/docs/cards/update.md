# PATCH /cards/:id

Cập nhật thông tin card với khả năng upload/thay thế avatar và cover image.

## Endpoint

```
PATCH /api/v1/cards/:id
```

## Authentication

✅ Yêu cầu authentication

## Headers

| Header | Value | Required |
|--------|-------|----------|
| Content-Type | multipart/form-data | ✅ Yes |
| Authorization | Bearer {token} | ✅ Yes |

## Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | ✅ Yes | Card ID |

## Request Body (Form Data)

Tất cả fields đều optional - chỉ gửi các fields cần update.

| Field | Type | Description |
|-------|------|-------------|
| cardName | string | Tên card |
| ownerName | string | Tên chủ thẻ |
| avatar | file | File ảnh đại diện mới (jpg, jpeg, png, gif, webp, max 2MB) |
| coverImage | file | File ảnh bìa mới (jpg, jpeg, png, gif, webp, max 5MB) |
| theme | JSON string | Theme của card (JSON format) |
| links | JSON string | Mảng các links (JSON format) |
| address | string | Địa chỉ |
| company | string | Công ty/Doanh nghiệp |
| description | string | Mô tả |
| phoneNumber | string | Số điện thoại |
| email | string | Email (valid email format) |

### File Upload Notes

- Khi upload file mới, file cũ sẽ tự động bị xóa khỏi server
- Nếu không gửi avatar hoặc coverImage, ảnh hiện tại sẽ được giữ nguyên
- Chỉ chấp nhận file ảnh với các định dạng: jpg, jpeg, png, gif, webp
- Avatar max 2MB, Cover Image max 5MB

### Example Request

Update only text fields (no file upload):

```bash
curl -X PATCH http://localhost:8080/api/v1/cards/507f1f77bcf86cd799439015 \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -F "phoneNumber=+84 987 654 321" \
  -F "company=New Company Inc" \
  -F "description=Lead Software Engineer"
```

Update with new avatar:

```bash
curl -X PATCH http://localhost:8080/api/v1/cards/507f1f77bcf86cd799439015 \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -F "avatar=@/path/to/new-avatar.jpg" \
  -F "phoneNumber=+84 987 654 321"
```

## Response

### Success Response (200 OK)

```json
{
  "_id": "507f1f77bcf86cd799439015",
  "userId": "507f1f77bcf86cd799439011",
  "cardName": "My Business Card",
  "ownerName": "John Doe",
  "email": "john@example.com",
  "phoneNumber": "+84 987 654 321",
  "company": "New Company Inc",
  "description": "Lead Software Engineer",
  "avatarUrl": "http://localhost:8080/uploads/avatars/avatar-1701234567890-a1b2c3d4e5f6.jpg",
  "coverImageUrl": "http://localhost:8080/uploads/covers/cover-1701234567890-x1y2z3a4b5c6.jpg",
  "theme": {
    "color": "#0ea5e9"
  },
  "links": [
    {
      "title": "Twitter",
      "url": "https://twitter.com/johndoe",
      "icon": "twitter"
    }
  ],
  "qrCodeUrl": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
  "isActive": true,
  "viewCount": 150,
  "createdAt": "2025-11-28T10:00:00.000Z",
  "updatedAt": "2025-11-28T11:30:00.000Z"
}
```

### Error Responses

#### 400 Bad Request - Validation Error

```json
{
  "statusCode": 400,
  "message": [
    "email must be an email"
  ],
  "error": "Bad Request"
}
```

#### 400 Bad Request - Invalid File Type

```json
{
  "statusCode": 400,
  "message": "Only image files are allowed (jpg, jpeg, png, gif, webp)",
  "error": "Bad Request"
}
```

#### 400 Bad Request - File Too Large

```json
{
  "statusCode": 400,
  "message": "File too large",
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
curl -X PATCH http://localhost:8080/api/v1/cards/507f1f77bcf86cd799439015 \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -F "phoneNumber=+84 987 654 321" \
  -F "company=New Company Inc" \
  -F "avatar=@/path/to/new-avatar.jpg" \
  -F 'links=[{"title":"Twitter","url":"https://twitter.com/johndoe","icon":"twitter"}]'
```

### JavaScript (Fetch with FormData)

```javascript
const token = localStorage.getItem('token');
const cardId = '507f1f77bcf86cd799439015';

// Create form data
const formData = new FormData();
formData.append('phoneNumber', '+84 987 654 321');
formData.append('company', 'New Company Inc');
formData.append('description', 'Lead Software Engineer');

// Add new avatar file if selected
const avatarFile = document.getElementById('avatarInput').files[0];
if (avatarFile) {
  formData.append('avatar', avatarFile);
}

// Add new cover image if selected
const coverFile = document.getElementById('coverInput').files[0];
if (coverFile) {
  formData.append('coverImage', coverFile);
}

// Update links
formData.append('links', JSON.stringify([
  {
    title: 'Twitter',
    url: 'https://twitter.com/johndoe',
    icon: 'twitter'
  }
]));

// Send request
const response = await fetch(`http://localhost:8080/api/v1/cards/${cardId}`, {
  method: 'PATCH',
  headers: {
    'Authorization': `Bearer ${token}`,
    // Don't set Content-Type, browser will set it automatically
  },
  body: formData,
});

const updatedCard = await response.json();
console.log('Updated card:', updatedCard);
```

### Python (requests)

```python
import requests
import json

token = "your_jwt_token_here"
card_id = "507f1f77bcf86cd799439015"
url = f"http://localhost:8080/api/v1/cards/{card_id}"
headers = {"Authorization": f"Bearer {token}"}

# Prepare data
data = {
    "phoneNumber": "+84 987 654 321",
    "company": "New Company Inc",
    "description": "Lead Software Engineer",
    "links": json.dumps([
        {"title": "Twitter", "url": "https://twitter.com/johndoe", "icon": "twitter"}
    ])
}

# Prepare files (optional)
files = {}
try:
    files["avatar"] = open("new-avatar.jpg", "rb")
except FileNotFoundError:
    pass  # No avatar update

response = requests.patch(url, headers=headers, data=data, files=files)

if response.status_code == 200:
    card = response.json()
    print(f"Card updated: {card['_id']}")
    print(f"New avatar URL: {card.get('avatarUrl')}")
```

## Notes

- Chỉ chủ card mới có quyền update
- Sử dụng `multipart/form-data` để support file upload
- File cũ sẽ tự động bị xóa khi upload file mới
- Nếu không gửi file, ảnh hiện tại sẽ được giữ nguyên
- Có thể update một hoặc nhiều fields
- `updatedAt` sẽ tự động được cập nhật
- QR code không thay đổi khi update card
- Files được lưu trong thư mục `uploads/` trên server
- Backend tự động generate và trả về full URLs cho images
