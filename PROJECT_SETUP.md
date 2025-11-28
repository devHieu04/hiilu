# HiiLu - Hướng dẫn Setup Chi tiết

## Yêu cầu hệ thống

- **Node.js**: v20.x trở lên
- **npm**: v10.x trở lên
- **MongoDB**: v7.x trở lên (hoặc sử dụng Docker)
- **Docker**: (Optional) cho containerized deployment

## Setup Nhanh

### Cách 1: Setup thủ công

#### Bước 1: Cài đặt dependencies

```bash
# Cài đặt dependencies cho root project
npm install

# Cài đặt dependencies cho cả backend và frontend
npm run install:all
```

#### Bước 2: Setup MongoDB

**Option A: Sử dụng MongoDB local**
```bash
# Cài đặt MongoDB trên macOS
brew install mongodb-community@7.0
brew services start mongodb-community@7.0

# Kiểm tra MongoDB đã chạy
mongosh
```

**Option B: Sử dụng Docker**
```bash
docker run -d -p 27017:27017 --name hiilu-mongodb mongo:7
```

#### Bước 3: Cấu hình Environment Variables

**Backend:**
```bash
cd backend
cp .env.example .env
# Chỉnh sửa .env nếu cần
```

**Frontend:**
```bash
cd frontend
cp .env.example .env.local
# Chỉnh sửa .env.local nếu cần
```

#### Bước 4: Chạy Development Server

**Chạy cả 2 services cùng lúc:**
```bash
# Từ root directory
npm run dev
```

**Hoặc chạy riêng từng service:**

```bash
# Terminal 1 - Backend
cd backend
npm run start:dev

# Terminal 2 - Frontend
cd frontend
npm run dev
```

#### Bước 5: Kiểm tra

- Frontend: http://localhost:8081
- Backend API: http://localhost:8080/api/v1
- MongoDB: mongodb://localhost:27017/hiilu

### Cách 2: Setup với Docker Compose (Recommended for Production)

```bash
# Build và start tất cả services
docker-compose up -d --build

# Xem logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop và xóa volumes
docker-compose down -v
```

## Chi tiết cấu hình từng phần

### Backend Configuration

**File cấu trúc:**
```
backend/
├── src/
│   ├── main.ts              # Entry point với cấu hình production-ready
│   ├── app.module.ts        # Root module với MongoDB connection
│   ├── common/              # Shared resources
│   │   ├── dto/            # Data Transfer Objects
│   │   ├── interfaces/     # TypeScript interfaces
│   │   └── constants/      # Application constants
│   ├── config/             # Configuration files
│   └── modules/            # Feature modules
├── .env                    # Environment variables
├── Dockerfile             # Production Docker image
└── package.json
```

**Environment Variables Explained:**

```env
# Application
NODE_ENV=development          # Environment: development | production | test
PORT=8080                    # Server port
API_PREFIX=api/v1           # API route prefix

# Database
MONGODB_URI=mongodb://localhost:27017/hiilu  # MongoDB connection string

# CORS
CORS_ORIGINS=http://localhost:8081  # Allowed origins (comma-separated)

# Security
JWT_SECRET=your_secret_here  # JWT signing secret (change in production!)
JWT_EXPIRATION=7d           # Token expiration time
```

**Production Features:**
- ✅ Helmet.js - Security headers
- ✅ Compression - Response compression
- ✅ CORS - Cross-origin resource sharing
- ✅ Validation - Global validation pipe
- ✅ MongoDB retry logic
- ✅ Environment-based configuration
- ✅ API versioning with prefix

### Frontend Configuration

**File cấu trúc:**
```
frontend/
├── app/
│   ├── layout.tsx          # Root layout
│   ├── page.tsx            # Home page
│   └── globals.css         # Global styles with Tailwind
├── components/             # React components
├── lib/
│   └── api.ts             # API client
├── types/
│   └── index.ts           # TypeScript types
├── public/                # Static assets
├── .env.local            # Environment variables
├── next.config.ts        # Next.js configuration
├── tailwind.config.ts    # Tailwind configuration
└── package.json
```

**Environment Variables Explained:**

```env
# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:8080/api/v1  # Backend API URL

# App Configuration
NEXT_PUBLIC_APP_NAME=HiiLu                        # Application name
NEXT_PUBLIC_APP_URL=http://localhost:8081         # Frontend URL
```

**Production Features:**
- ✅ Next.js 14 with App Router
- ✅ TypeScript strict mode
- ✅ TailwindCSS v4
- ✅ Security headers
- ✅ Image optimization
- ✅ Response compression
- ✅ SEO optimization
- ✅ Vietnamese font support

## Development Workflow

### 1. Tạo Feature Module mới (Backend)

```bash
cd backend

# Tạo module mới
nest g module modules/users
nest g controller modules/users
nest g service modules/users

# Tạo DTO
nest g class modules/users/dto/create-user.dto --no-spec

# Tạo Schema
touch src/modules/users/schemas/user.schema.ts
```

### 2. Tạo Component mới (Frontend)

```bash
cd frontend

# Tạo component
mkdir -p components/Card
touch components/Card/Card.tsx
touch components/Card/index.ts

# Tạo page mới
mkdir -p app/dashboard
touch app/dashboard/page.tsx
```

### 3. Testing

**Backend:**
```bash
cd backend

# Unit tests
npm run test

# E2E tests
npm run test:e2e

# Test coverage
npm run test:cov
```

**Frontend:**
```bash
cd frontend

# Type checking
npm run type-check

# Linting
npm run lint
```

## Production Deployment

### 1. Build cho Production

```bash
# Build tất cả
npm run build

# Hoặc build riêng
npm run build:backend
npm run build:frontend
```

### 2. Chạy Production Server

```bash
# Chạy tất cả
npm run start

# Hoặc chạy riêng
npm run start:backend
npm run start:frontend
```

### 3. Docker Production Deployment

**Tạo production docker-compose:**
```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  mongodb:
    image: mongo:7-jammy
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
    volumes:
      - mongodb_data:/data/db

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    restart: always
    environment:
      NODE_ENV: production
      MONGODB_URI: mongodb://admin:${MONGO_PASSWORD}@mongodb:27017/hiilu?authSource=admin

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    restart: always

volumes:
  mongodb_data:
```

**Deploy:**
```bash
docker-compose -f docker-compose.prod.yml up -d --build
```

## Troubleshooting

### MongoDB Connection Issues

```bash
# Kiểm tra MongoDB status
brew services list

# Restart MongoDB
brew services restart mongodb-community@7.0

# Test connection
mongosh mongodb://localhost:27017/hiilu
```

### Port đã được sử dụng

```bash
# Tìm process đang dùng port 8080
lsof -i :8080

# Kill process
kill -9 <PID>

# Hoặc đổi port trong .env
PORT=8090
```

### Node modules issues

```bash
# Xóa và cài lại
cd backend && rm -rf node_modules package-lock.json && npm install
cd frontend && rm -rf node_modules package-lock.json && npm install
```

### Docker issues

```bash
# Xóa tất cả containers và volumes
docker-compose down -v

# Rebuild from scratch
docker-compose up -d --build --force-recreate
```

## Useful Commands

```bash
# Root level commands
npm run dev              # Start both backend & frontend
npm run build           # Build both projects
npm run start           # Start both in production mode
npm run install:all     # Install all dependencies

# Docker commands
npm run docker:up       # Start all services
npm run docker:down     # Stop all services
npm run docker:logs     # View logs

# Backend specific
cd backend
npm run start:dev       # Development mode
npm run start:prod      # Production mode
npm run test           # Run tests
npm run lint           # Lint code

# Frontend specific
cd frontend
npm run dev            # Development mode
npm run build          # Build for production
npm run start          # Production mode
npm run type-check     # TypeScript check
```

## Next Steps

1. Implement authentication module
2. Create user management
3. Build smart card features
4. Add QR code generation
5. Implement analytics
6. Add tests
7. Setup CI/CD pipeline
8. Configure monitoring

## Resources

- [NestJS Documentation](https://docs.nestjs.com/)
- [Next.js Documentation](https://nextjs.org/docs)
- [TailwindCSS Documentation](https://tailwindcss.com/docs)
- [MongoDB Documentation](https://docs.mongodb.com/)
