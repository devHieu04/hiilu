# HiiLu - Project Structure

## 📁 Cấu trúc tổng quan

```
HILU/
├── 📄 Configuration Files
│   ├── package.json              # Root package với scripts chung
│   ├── docker-compose.yml        # Docker orchestration
│   ├── Makefile                  # Make commands
│   ├── .gitignore               # Git ignore rules
│   └── .vscode/                 # VSCode settings
│
├── 📚 Documentation
│   ├── README.md                # Hướng dẫn tổng quan
│   ├── QUICK_START.md          # Hướng dẫn bắt đầu nhanh
│   ├── PROJECT_SETUP.md        # Hướng dẫn setup chi tiết
│   └── PROJECT_STRUCTURE.md    # File này
│
├── 🔧 Backend (NestJS)
│   ├── src/
│   │   ├── main.ts             # Entry point với production configs
│   │   ├── app.module.ts       # Root module với MongoDB
│   │   ├── app.controller.ts   # Root controller
│   │   ├── app.service.ts      # Root service
│   │   │
│   │   ├── common/             # Shared resources
│   │   │   ├── dto/           # Data Transfer Objects
│   │   │   │   └── pagination.dto.ts
│   │   │   ├── interfaces/    # TypeScript interfaces
│   │   │   │   └── api-response.interface.ts
│   │   │   ├── constants/     # Constants
│   │   │   │   └── index.ts
│   │   │   ├── decorators/    # Custom decorators (empty)
│   │   │   ├── guards/        # Auth guards (empty)
│   │   │   ├── interceptors/  # Interceptors (empty)
│   │   │   └── filters/       # Exception filters (empty)
│   │   │
│   │   ├── config/            # Configuration modules (empty)
│   │   └── modules/           # Feature modules (empty)
│   │
│   ├── test/                  # E2E tests
│   ├── .env                   # Environment variables (gitignored)
│   ├── .env.example          # Environment template
│   ├── Dockerfile            # Production Docker image
│   ├── .dockerignore        # Docker ignore rules
│   ├── package.json         # Backend dependencies
│   ├── tsconfig.json        # TypeScript config
│   └── nest-cli.json        # NestJS CLI config
│
└── 🎨 Frontend (Next.js)
    ├── app/                  # Next.js App Router
    │   ├── layout.tsx       # Root layout
    │   ├── page.tsx         # Home page
    │   └── globals.css      # Global styles + Tailwind
    │
    ├── components/          # React components (empty)
    ├── lib/                # Utilities
    │   └── api.ts          # API client
    ├── types/              # TypeScript types
    │   └── index.ts        # Common types
    ├── utils/              # Utility functions (empty)
    ├── public/             # Static assets (empty)
    │
    ├── .env.local          # Environment variables (gitignored)
    ├── .env.example        # Environment template
    ├── Dockerfile          # Production Docker image
    ├── .dockerignore       # Docker ignore rules
    ├── package.json        # Frontend dependencies
    ├── next.config.ts      # Next.js config
    ├── tailwind.config.ts  # Tailwind config
    ├── postcss.config.mjs  # PostCSS config
    ├── tsconfig.json       # TypeScript config
    └── .eslintrc.json      # ESLint config
```

## 🔑 File quan trọng

### Root Level
| File | Mục đích |
|------|----------|
| `package.json` | Scripts để chạy cả backend và frontend |
| `docker-compose.yml` | Orchestrate MongoDB, Backend, Frontend |
| `Makefile` | Shortcuts cho các commands thường dùng |
| `.gitignore` | Ignore node_modules, .env, build files |

### Backend
| File | Mục đích |
|------|----------|
| `src/main.ts` | Entry point với Helmet, CORS, Compression, Validation |
| `src/app.module.ts` | Root module với MongoDB connection |
| `.env` | PORT=8080, MONGODB_URI, CORS_ORIGINS, JWT config |
| `Dockerfile` | Multi-stage build cho production |

### Frontend
| File | Mục đích |
|------|----------|
| `app/layout.tsx` | Root layout với metadata, fonts |
| `app/page.tsx` | Landing page với HiiLu giới thiệu |
| `app/globals.css` | Tailwind imports + custom styles |
| `lib/api.ts` | API client để call backend |
| `.env.local` | NEXT_PUBLIC_API_URL và app configs |
| `next.config.ts` | Security headers, image optimization |
| `Dockerfile` | Multi-stage build cho production |

## 🚀 Tech Stack Chi tiết

### Backend Stack
```
NestJS v11          → Framework
TypeScript v5       → Language
MongoDB v8          → Database
Mongoose v8         → ODM
Helmet              → Security headers
Compression         → Response compression
CORS                → Cross-origin support
Class-validator     → DTO validation
Class-transformer   → DTO transformation
```

### Frontend Stack
```
Next.js v14         → React framework (App Router)
React v19           → UI library
TypeScript v5       → Language
TailwindCSS v4      → Styling
PostCSS             → CSS processing
ESLint              → Linting
```

### DevOps
```
Docker              → Containerization
Docker Compose      → Multi-container orchestration
Node v20-alpine     → Base image
```

## 📡 Ports & URLs

| Service | Port | URL | Environment |
|---------|------|-----|-------------|
| Frontend | 8081 | http://localhost:8081 | Development |
| Backend API | 8080 | http://localhost:8080/api/v1 | Development |
| MongoDB | 27017 | mongodb://localhost:27017/hiilu | Development |

## 🔐 Environment Variables

### Backend (.env)
```env
NODE_ENV=development
PORT=8080
API_PREFIX=api/v1
MONGODB_URI=mongodb://localhost:27017/hiilu
CORS_ORIGINS=http://localhost:8081
JWT_SECRET=change_this_in_production
JWT_EXPIRATION=7d
```

### Frontend (.env.local)
```env
NEXT_PUBLIC_API_URL=http://localhost:8080/api/v1
NEXT_PUBLIC_APP_NAME=HiiLu
NEXT_PUBLIC_APP_URL=http://localhost:8081
```

## 🎯 Features đã implement

### Backend
- ✅ NestJS với TypeScript
- ✅ MongoDB integration với Mongoose
- ✅ Environment-based configuration
- ✅ Security (Helmet, CORS)
- ✅ Compression
- ✅ Global validation pipe
- ✅ API versioning (/api/v1)
- ✅ Production-ready Dockerfile
- ✅ Common DTOs (Pagination)
- ✅ Common interfaces (API Response)
- ✅ Constants management

### Frontend
- ✅ Next.js 14 App Router
- ✅ TypeScript strict mode
- ✅ TailwindCSS v4
- ✅ Responsive layout
- ✅ Landing page với HiiLu introduction
- ✅ API client utility
- ✅ Type definitions
- ✅ SEO optimization
- ✅ Security headers
- ✅ Production-ready Dockerfile
- ✅ Vietnamese font support

### DevOps
- ✅ Docker Compose setup
- ✅ Multi-stage Docker builds
- ✅ Health checks
- ✅ Volume persistence
- ✅ Network isolation
- ✅ Makefile shortcuts

## 📝 Next Steps (Gợi ý phát triển)

### Phase 1: Authentication
```
backend/src/modules/
└── auth/
    ├── auth.module.ts
    ├── auth.controller.ts
    ├── auth.service.ts
    ├── dto/
    │   ├── login.dto.ts
    │   ├── register.dto.ts
    │   └── refresh-token.dto.ts
    ├── guards/
    │   └── jwt-auth.guard.ts
    └── strategies/
        └── jwt.strategy.ts
```

### Phase 2: User Management
```
backend/src/modules/
└── users/
    ├── users.module.ts
    ├── users.controller.ts
    ├── users.service.ts
    ├── schemas/
    │   └── user.schema.ts
    └── dto/
        ├── create-user.dto.ts
        └── update-user.dto.ts
```

### Phase 3: Smart Cards
```
backend/src/modules/
└── cards/
    ├── cards.module.ts
    ├── cards.controller.ts
    ├── cards.service.ts
    ├── schemas/
    │   └── card.schema.ts
    └── dto/
        ├── create-card.dto.ts
        └── update-card.dto.ts
```

### Frontend Components
```
frontend/components/
├── auth/
│   ├── LoginForm.tsx
│   └── RegisterForm.tsx
├── cards/
│   ├── CardEditor.tsx
│   ├── CardPreview.tsx
│   └── CardList.tsx
├── common/
│   ├── Header.tsx
│   ├── Footer.tsx
│   └── Layout.tsx
└── ui/
    ├── Button.tsx
    ├── Input.tsx
    └── Modal.tsx
```

## 🛠️ Commands Reference

Xem [QUICK_START.md](QUICK_START.md) hoặc chạy `make help` để xem tất cả commands.

## 📚 Documentation Links

- [README.md](README.md) - Tổng quan project
- [QUICK_START.md](QUICK_START.md) - Bắt đầu nhanh 3 phút
- [PROJECT_SETUP.md](PROJECT_SETUP.md) - Setup chi tiết từng bước
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - File này

---

Last updated: November 18, 2025
