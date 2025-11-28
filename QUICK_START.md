# Quick Start Guide - HiiLu

## 🚀 Chạy nhanh trong 3 phút

### Điều kiện tiên quyết
- Node.js v20+ đã cài đặt
- MongoDB đang chạy (hoặc sử dụng Docker)

### Bước 1: Cài đặt (1 phút)

```bash
# Clone và vào thư mục project
cd HILU

# Cài đặt tất cả dependencies
npm run install:all
```

### Bước 2: Cấu hình (30 giây)

```bash
# Backend
cd backend
cp .env.example .env

# Frontend
cd ../frontend
cp .env.example .env.local

cd ..
```

### Bước 3: Chạy MongoDB (30 giây)

**Cách 1: Sử dụng Docker (Đơn giản nhất)**
```bash
docker run -d -p 27017:27017 --name hiilu-mongodb mongo:7
```

**Cách 2: Sử dụng MongoDB đã cài sẵn**
```bash
# macOS
brew services start mongodb-community@7.0

# Linux
sudo systemctl start mongod

# Windows
net start MongoDB
```

### Bước 4: Chạy ứng dụng (1 phút)

```bash
# Chạy cả backend và frontend
npm run dev
```

### 🎉 Xong!

Truy cập:
- **Frontend**: http://localhost:8081
- **Backend API**: http://localhost:8080/api/v1

---

## 🐳 Hoặc sử dụng Docker (Đơn giản hơn)

```bash
# Chạy tất cả (MongoDB + Backend + Frontend)
docker-compose up -d

# Xem logs
docker-compose logs -f

# Dừng
docker-compose down
```

---

## 📋 Sử dụng Makefile (Nếu có make)

```bash
make install     # Cài đặt dependencies
make dev        # Chạy development
make build      # Build production
make docker-up  # Chạy với Docker
```

Xem tất cả commands: `make help`

---

## ⚡ Commands hữu ích

```bash
# Development
npm run dev              # Chạy cả 2 (backend + frontend)
npm run dev:backend     # Chỉ chạy backend
npm run dev:frontend    # Chỉ chạy frontend

# Production
npm run build           # Build cả 2
npm run start           # Chạy production

# Docker
npm run docker:up       # Start containers
npm run docker:down     # Stop containers
npm run docker:logs     # Xem logs
```

---

## 🔧 Troubleshooting

**Port đã được sử dụng?**
```bash
# Thay đổi port trong .env
# Backend: PORT=8090
# Frontend: Sửa trong package.json script "dev": "next dev -p 8082"
```

**MongoDB không kết nối được?**
```bash
# Kiểm tra MongoDB đang chạy
mongosh mongodb://localhost:27017

# Hoặc dùng Docker
docker ps | grep mongo
```

**Module not found?**
```bash
# Cài lại dependencies
npm run install:all
```

---

## 📚 Tài liệu đầy đủ

Xem [README.md](README.md) và [PROJECT_SETUP.md](PROJECT_SETUP.md) để biết thêm chi tiết.

---

Happy Coding! 🎨
