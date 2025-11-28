.PHONY: help install dev build start clean docker-up docker-down docker-logs test

help: ## Hiển thị help message
	@echo "HiiLu Project - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Cài đặt tất cả dependencies
	@echo "Installing dependencies..."
	npm install
	cd backend && npm install
	cd frontend && npm install
	@echo "✓ All dependencies installed"

dev: ## Chạy development server (cả backend và frontend)
	@echo "Starting development servers..."
	npm run dev

dev-backend: ## Chạy backend development server
	cd backend && npm run start:dev

dev-frontend: ## Chạy frontend development server
	cd frontend && npm run dev

build: ## Build cả backend và frontend
	@echo "Building projects..."
	npm run build
	@echo "✓ Build completed"

build-backend: ## Build backend
	cd backend && npm run build

build-frontend: ## Build frontend
	cd frontend && npm run build

start: ## Chạy production server
	@echo "Starting production servers..."
	npm run start

start-backend: ## Chạy backend production server
	cd backend && npm run start:prod

start-frontend: ## Chạy frontend production server
	cd frontend && npm run start

clean: ## Xóa node_modules và build files
	@echo "Cleaning project..."
	rm -rf node_modules package-lock.json
	rm -rf backend/node_modules backend/package-lock.json backend/dist
	rm -rf frontend/node_modules frontend/package-lock.json frontend/.next
	@echo "✓ Cleaned"

docker-up: ## Start Docker containers
	docker-compose up -d
	@echo "✓ Docker containers started"
	@echo "  Frontend: http://localhost:8081"
	@echo "  Backend: http://localhost:8080"

docker-down: ## Stop Docker containers
	docker-compose down
	@echo "✓ Docker containers stopped"

docker-logs: ## Xem Docker logs
	docker-compose logs -f

docker-rebuild: ## Rebuild và restart Docker containers
	docker-compose down
	docker-compose up -d --build
	@echo "✓ Docker containers rebuilt and started"

test: ## Chạy tests
	cd backend && npm run test

test-backend: ## Chạy backend tests
	cd backend && npm run test

lint: ## Chạy linter
	cd backend && npm run lint
	cd frontend && npm run lint

type-check: ## Kiểm tra TypeScript types
	cd frontend && npm run type-check
