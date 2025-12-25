# HiiLu Deployment Guide

## 🌐 Production Domains
- **Frontend**: https://hilu.pics
- **Backend API**: https://api.hilu.pics

## 📋 Server Deployment Steps

### 1. Pull Latest Code
```bash
cd ~/hiilu
git pull origin main
```

### 2. Create/Update .env File
Create or update the `.env` file in the project root:

```bash
nano .env
```

Copy this content and update with your values:

```env
# Application
NODE_ENV=production
PORT=8080
API_PREFIX=api/v1

# Database - MongoDB Atlas
MONGODB_URI=mongodb+srv://duyhieu:Duyhieu2005@cluster0.j1akebg.mongodb.net/?appName=Hilu

# CORS - Allow both local and production domains
CORS_ORIGINS=http://localhost:8081,https://hilu.pics,https://www.hilu.pics

# Security
JWT_SECRET=070be02e2dd98d10f10dcb3658ec6061b1158f2d40dff0793b30b59f192b71996258cf9e7e828ff4f5c7bd18c745bacb3fe4a6d6735478818960a9b9eb1fb1f1
JWT_EXPIRATION=7d

# Domain Configuration
BACKEND_URL=https://api.hilu.pics
FRONTEND_URL=https://hilu.pics

# Frontend URL (for QR code generation and links)
NEXT_PUBLIC_APP_URL=https://hilu.pics
NEXT_PUBLIC_API_URL=https://api.hilu.pics/api/v1
```

### 3. Rebuild Docker Containers

**IMPORTANT**: Frontend needs to be rebuilt to embed the correct API URL at build time.

```bash
# Stop and remove old containers
docker compose down

# Rebuild with no cache (recommended for first deployment)
docker compose build --no-cache

# Or rebuild without cache flag (faster)
docker compose build

# Start containers
docker compose up -d
```

### 4. Verify Deployment

Check if containers are running:
```bash
docker ps
```

You should see:
- `hiilu-backend` on port 8080
- `hiilu-frontend` on port 8081

Check backend logs:
```bash
docker logs hiilu-backend --tail 50
```

Check frontend logs:
```bash
docker logs hiilu-frontend --tail 50
```

### 5. Test API Endpoints

Test backend API:
```bash
curl http://localhost:8080/api/v1
```

Should return: `{"message":"HiiLu API v1"}`

## 🔧 Nginx Configuration

### Backend (api.hilu.pics)
```nginx
server {
    listen 80;
    server_name api.hilu.pics;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### Frontend (hilu.pics)
```nginx
server {
    listen 80;
    server_name hilu.pics www.hilu.pics;

    location / {
        proxy_pass http://localhost:8081;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### Enable HTTPS with Certbot
```bash
sudo certbot --nginx -d api.hilu.pics
sudo certbot --nginx -d hilu.pics -d www.hilu.pics
```

## 🔍 Troubleshooting

### Frontend still calling localhost
This happens when environment variables are not set during build. Solution:
```bash
# Rebuild frontend with explicit env vars
docker compose build --no-cache frontend
docker compose up -d frontend
```

### Check environment variables in running container
```bash
docker exec hiilu-frontend env | grep NEXT_PUBLIC
```

### MongoDB connection issues
Check if MongoDB Atlas allows your server IP:
1. Go to MongoDB Atlas → Network Access
2. Add your server's IP address

### CORS errors
Make sure CORS_ORIGINS in `.env` includes your domain:
```env
CORS_ORIGINS=https://hilu.pics,https://www.hilu.pics
```

## 📱 iOS App Configuration

The iOS app is configured to use production domain:
- API URL: `https://api.hilu.pics/api/v1`

To switch back to local development, edit `Hiilu/Hiilu/Constants/APIConfig.swift`:
```swift
// Development
static let baseURL = "http://localhost:8080/api/v1"

// Production
// static let baseURL = "https://api.hilu.pics/api/v1"
```

## 🔄 Update Process

When you need to update the application:

```bash
# 1. Pull latest code
git pull origin main

# 2. Rebuild and restart
docker compose down
docker compose build
docker compose up -d

# 3. Check logs
docker logs hiilu-backend -f
docker logs hiilu-frontend -f
```

## 📊 Monitoring

View real-time logs:
```bash
# All containers
docker compose logs -f

# Specific container
docker logs hiilu-backend -f
docker logs hiilu-frontend -f
```

Check container health:
```bash
docker ps
docker compose ps
```

## 🚨 Common Issues

### Issue: Frontend shows "Cannot connect to API"
**Solution**: Check if backend is running and accessible
```bash
curl http://localhost:8080/api/v1
docker logs hiilu-backend --tail 50
```

### Issue: Backend can't connect to MongoDB
**Solution**: Verify MONGODB_URI in .env file
```bash
cat .env | grep MONGODB_URI
docker logs hiilu-backend | grep -i mongo
```

### Issue: Docker build fails with "package-lock.json not found"
**Solution**: Make sure you pulled the latest code with package-lock.json files
```bash
git pull origin main
ls -la backend/package-lock.json
ls -la frontend/package-lock.json
```

## 📝 Notes

- `.env` file is NOT committed to Git for security reasons
- Always backup your `.env` file
- Keep your JWT_SECRET secure and never share it
- MongoDB credentials should be rotated regularly
- Monitor your MongoDB Atlas usage to avoid overages
