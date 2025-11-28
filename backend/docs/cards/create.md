# POST /cards

Tạo smart card mới với khả năng upload avatar và cover image.

## Endpoint

```
POST /api/v1/cards
```

## Authentication

✅ Yêu cầu authentication

## Headers

| Header | Value | Required |
|--------|-------|----------|
| Content-Type | multipart/form-data | ✅ Yes |
| Authorization | Bearer {token} | ✅ Yes |

## Request Body (Form Data)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| cardName | string | ✅ Yes | Tên card |
| ownerName | string | ✅ Yes | Tên chủ thẻ |
| avatar | file | ❌ No | File ảnh đại diện (jpg, jpeg, png, gif, webp, max 2MB) |
| coverImage | file | ❌ No | File ảnh bìa (jpg, jpeg, png, gif, webp, max 5MB) |
| theme | JSON string | ❌ No | Theme của card (JSON format) |
| links | JSON string | ❌ No | Mảng các links (JSON format) |
| address | string | ❌ No | Địa chỉ |
| company | string | ❌ No | Công ty/Doanh nghiệp |
| description | string | ❌ No | Mô tả |
| phoneNumber | string | ❌ No | Số điện thoại |
| email | string | ❌ No | Email (valid email format) |

### File Upload Requirements

**Avatar:**
- Allowed formats: jpg, jpeg, png, gif, webp
- Maximum size: 2MB
- Recommended dimensions: 400x400px (square)

**Cover Image:**
- Allowed formats: jpg, jpeg, png, gif, webp
- Maximum size: 5MB
- Recommended dimensions: 1200x600px (2:1 ratio)

### Theme Object Format

```json
{
  "color": "#0ea5e9",
  "icon": "briefcase"
}
```

### Links Array Format

```json
[
  {
    "title": "Website",
    "url": "https://johndoe.com",
    "icon": "globe"
  },
  {
    "title": "LinkedIn",
    "url": "https://linkedin.com/in/johndoe",
    "icon": "linkedin"
  }
]
```

## Response

### Success Response (201 Created)

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
  "avatarUrl": "http://localhost:8080/uploads/avatars/avatar-1701234567890-a1b2c3d4e5f6.jpg",
  "coverImageUrl": "http://localhost:8080/uploads/covers/cover-1701234567890-x1y2z3a4b5c6.jpg",
  "theme": {
    "color": "#0ea5e9",
    "icon": "briefcase"
  },
  "links": [
    {
      "title": "Website",
      "url": "https://johndoe.com",
      "icon": "globe"
    },
    {
      "title": "LinkedIn",
      "url": "https://linkedin.com/in/johndoe",
      "icon": "linkedin"
    }
  ],
  "qrCodeUrl": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
  "isActive": true,
  "viewCount": 0,
  "createdAt": "2025-11-28T10:00:00.000Z",
  "updatedAt": "2025-11-28T10:00:00.000Z"
}
```

**Note**: `avatarUrl` và `coverImageUrl` được trả về dưới dạng URLs đầy đủ từ backend, không phải file paths.

### Error Responses

#### 400 Bad Request - Validation Error

```json
{
  "statusCode": 400,
  "message": [
    "cardName should not be empty",
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

## Example

### cURL

```bash
curl -X POST http://localhost:8080/api/v1/cards \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -F "cardName=My Business Card" \
  -F "ownerName=John Doe" \
  -F "email=john@example.com" \
  -F "phoneNumber=+84 123 456 789" \
  -F "company=Tech Corp" \
  -F "address=123 Main St, Ho Chi Minh City" \
  -F "description=Senior Software Engineer" \
  -F "avatar=@/path/to/avatar.jpg" \
  -F "coverImage=@/path/to/cover.jpg" \
  -F 'theme={"color":"#0ea5e9","icon":"briefcase"}' \
  -F 'links=[{"title":"Website","url":"https://johndoe.com","icon":"globe"}]'
```

### JavaScript (Fetch with FormData)

```javascript
const token = localStorage.getItem('token');

// Create form data
const formData = new FormData();
formData.append('cardName', 'My Business Card');
formData.append('ownerName', 'John Doe');
formData.append('email', 'john@example.com');
formData.append('phoneNumber', '+84 123 456 789');
formData.append('company', 'Tech Corp');
formData.append('address', '123 Main St, Ho Chi Minh City');
formData.append('description', 'Senior Software Engineer');

// Add files
const avatarFile = document.getElementById('avatarInput').files[0];
const coverFile = document.getElementById('coverInput').files[0];
if (avatarFile) {
  formData.append('avatar', avatarFile);
}
if (coverFile) {
  formData.append('coverImage', coverFile);
}

// Add theme and links as JSON strings
formData.append('theme', JSON.stringify({
  color: '#0ea5e9',
  icon: 'briefcase'
}));

formData.append('links', JSON.stringify([
  {
    title: 'Website',
    url: 'https://johndoe.com',
    icon: 'globe'
  },
  {
    title: 'LinkedIn',
    url: 'https://linkedin.com/in/johndoe',
    icon: 'linkedin'
  }
]));

// Send request
const response = await fetch('http://localhost:8080/api/v1/cards', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    // Don't set Content-Type header, browser will set it automatically with boundary
  },
  body: formData,
});

const card = await response.json();
console.log('Created card:', card);
```

### Python (requests with files)

```python
import requests
import json

token = "your_jwt_token_here"
url = "http://localhost:8080/api/v1/cards"
headers = {"Authorization": f"Bearer {token}"}

# Prepare data
data = {
    "cardName": "My Business Card",
    "ownerName": "John Doe",
    "email": "john@example.com",
    "phoneNumber": "+84 123 456 789",
    "company": "Tech Corp",
    "address": "123 Main St, Ho Chi Minh City",
    "description": "Senior Software Engineer",
    "theme": json.dumps({"color": "#0ea5e9", "icon": "briefcase"}),
    "links": json.dumps([
        {"title": "Website", "url": "https://johndoe.com", "icon": "globe"}
    ])
}

# Prepare files
files = {
    "avatar": open("avatar.jpg", "rb"),
    "coverImage": open("cover.jpg", "rb")
}

response = requests.post(url, headers=headers, data=data, files=files)

if response.status_code == 201:
    card = response.json()
    print(f"Card created: {card['_id']}")
    print(f"Avatar URL: {card.get('avatarUrl')}")
    print(f"Cover URL: {card.get('coverImageUrl')}")
```

## Notes

- Request sử dụng `multipart/form-data` để support file upload
- Files được upload lên server và URLs được backend tự động generate
- `avatarUrl` và `coverImageUrl` trong response là full URLs, không phải file paths
- QR code được tự động generate sau khi tạo card
- Theme và links phải được gửi dưới dạng JSON strings trong form data
- Files được lưu trong thư mục `uploads/` trên server
- Files được rename tự động để tránh conflict
- Chỉ chấp nhận file ảnh với các định dạng: jpg, jpeg, png, gif, webp
