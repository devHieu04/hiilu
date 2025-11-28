# HiiLu - Smart Digital Card Platform

Trong thế giới nơi mọi thứ đều đang được số hóa, HiiLu mang đến cách kết nối hoàn toàn mới giúp bạn tạo dấu ấn chuyên nghiệp và bền vững hơn bao giờ hết.

Dù bạn là freelancer, doanh nhân, sinh viên hay doanh nghiệp, HiiLu giúp bạn truyền tải bản sắc thương hiệu và tạo ấn tượng trong từng lần chạm.

## Tech Stack

### Backend
- **Framework**: NestJS
- **Database**: MongoDB
- **Language**: TypeScript
- **Port**: 8080

### Frontend
- **Framework**: Next.js 14 (App Router)
- **Styling**: TailwindCSS
- **Language**: TypeScript
- **Port**: 8081

## Project Structure

```
HILU/
├── backend/                 # NestJS Backend Application
│   ├── src/
│   │   ├── common/         # Common utilities, DTOs, interfaces
│   │   ├── config/         # Configuration files
│   │   ├── modules/        # Feature modules
│   │   ├── app.module.ts   # Root module
│   │   └── main.ts         # Application entry point
│   ├── Dockerfile
│   ├── .env.example
│   └── package.json
│
├── frontend/               # Next.js Frontend Application
│   ├── app/               # Next.js App Router
│   ├── components/        # React components
│   ├── lib/              # Utilities and helpers
│   ├── types/            # TypeScript type definitions
│   ├── public/           # Static assets
│   ├── Dockerfile
│   ├── .env.example
│   └── package.json
│
└── docker-compose.yml     # Docker Compose configuration
```

## Prerequisites

- Node.js 20.x or higher
- npm or yarn
- MongoDB 7.x (or use Docker)
- Docker & Docker Compose (optional, for containerized deployment)

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd HILU
```

### 2. Setup Backend

```bash
cd backend

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Edit .env and configure your MongoDB URI and other settings
# Default MongoDB URI: mongodb://localhost:27017/hiilu

# Run in development mode
npm run start:dev

# Build for production
npm run build

# Run in production mode
npm run start:prod
```

Backend will be available at: `http://localhost:8080`
API endpoint: `http://localhost:8080/api/v1`

### 3. Setup Frontend

```bash
cd frontend

# Install dependencies
npm install

# Copy environment file
cp .env.example .env.local

# Run in development mode
npm run dev

# Build for production
npm run build

# Run in production mode
npm run start
```

Frontend will be available at: `http://localhost:8081`

## Running with Docker

### Development

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

### Production Build

```bash
# Build and start all services
docker-compose up -d --build

# Services will be available at:
# - Frontend: http://localhost:8081
# - Backend: http://localhost:8080
# - MongoDB: localhost:27017
```

## Environment Variables

### Backend (.env)

```env
NODE_ENV=development
PORT=8080
API_PREFIX=api/v1
MONGODB_URI=mongodb://localhost:27017/hiilu
CORS_ORIGINS=http://localhost:8081
JWT_SECRET=your_jwt_secret_here
JWT_EXPIRATION=7d
```

### Frontend (.env.local)

```env
NEXT_PUBLIC_API_URL=http://localhost:8080/api/v1
NEXT_PUBLIC_APP_NAME=HiiLu
NEXT_PUBLIC_APP_URL=http://localhost:8081
```

## Available Scripts

### Backend

- `npm run start:dev` - Start development server with hot reload
- `npm run start:prod` - Start production server
- `npm run build` - Build for production
- `npm run test` - Run tests
- `npm run lint` - Run ESLint

### Frontend

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint
- `npm run type-check` - Run TypeScript type checking

## Features

### Core Features (MVP)
- [ ] User authentication and authorization
- [ ] Digital card creation and management
- [ ] Card sharing and QR code generation
- [ ] Contact information management
- [ ] Analytics and insights
- [ ] Responsive design for mobile and desktop

### Security Features
- Helmet.js for security headers
- CORS configuration
- Input validation with class-validator
- Environment variable management
- MongoDB connection with retry logic

### Performance Optimizations
- Compression middleware
- Image optimization (Next.js)
- Static site generation (SSG)
- Server-side rendering (SSR)
- API response caching strategies

## API Documentation

API endpoints will be available at: `http://localhost:8080/api/v1`

### Health Check
- `GET /api/v1` - API health check

## Development Guidelines

### Code Style
- Use TypeScript for type safety
- Follow ESLint rules
- Use Prettier for code formatting
- Write meaningful commit messages

### Git Workflow
1. Create feature branch from `main`
2. Make changes and commit
3. Push to remote
4. Create pull request
5. Code review and merge

## Deployment

### Backend Deployment
1. Set environment variables
2. Build the application: `npm run build`
3. Start the server: `npm run start:prod`

### Frontend Deployment
1. Set environment variables
2. Build the application: `npm run build`
3. Start the server: `npm run start`

### Docker Deployment
```bash
docker-compose -f docker-compose.yml up -d --build
```

## Monitoring and Logging

- Application logs are output to console
- Use log levels: error, warn, log, debug, verbose
- Monitor application health with health check endpoints

## Troubleshooting

### Common Issues

**MongoDB Connection Failed**
- Ensure MongoDB is running
- Check MONGODB_URI in .env file
- Verify network connectivity

**Port Already in Use**
- Check if ports 8080 or 8081 are already in use
- Change ports in .env files if needed

**Module Not Found**
- Run `npm install` in the respective directory
- Clear node_modules and reinstall

## License

Private - All rights reserved

## Support

For issues and questions, please contact the development team.

---

Built with ❤️ by HiiLu Team
