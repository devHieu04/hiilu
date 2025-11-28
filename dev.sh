#!/bin/bash

# HiiLu Development Script
# Quản lý development servers dễ dàng

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       HiiLu Development Manager${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

check_backend() {
    if curl -s http://localhost:8080/api/v1 > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

check_frontend() {
    if curl -s http://localhost:8081 > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

check_mongodb() {
    if mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

status() {
    print_header
    echo "Server Status:"
    echo ""

    if check_mongodb; then
        print_success "MongoDB: Running on port 27017"
    else
        print_error "MongoDB: Not running"
    fi

    if check_backend; then
        print_success "Backend: Running on http://localhost:8080"
    else
        print_error "Backend: Not running"
    fi

    if check_frontend; then
        print_success "Frontend: Running on http://localhost:8081"
    else
        print_error "Frontend: Not running"
    fi
    echo ""
}

start_all() {
    print_header
    print_info "Starting all services..."
    echo ""

    # Check MongoDB
    if ! check_mongodb; then
        print_error "MongoDB is not running!"
        print_info "Please start MongoDB first:"
        echo "  - Docker: docker run -d -p 27017:27017 --name hiilu-mongodb mongo:7"
        echo "  - macOS: brew services start mongodb-community@7.0"
        echo ""
    else
        print_success "MongoDB is running"
    fi

    # Start backend and frontend
    print_info "Starting backend and frontend..."
    npm run dev
}

stop_all() {
    print_header
    print_info "Stopping all services..."

    # Kill processes on ports
    pkill -f "npm run start:dev" || true
    pkill -f "next dev" || true

    print_success "All services stopped"
}

restart() {
    stop_all
    sleep 2
    start_all
}

logs() {
    print_header
    print_info "Showing logs (Ctrl+C to exit)..."

    # This assumes servers are running in background
    tail -f backend/logs/*.log 2>/dev/null || echo "No log files found"
}

install_deps() {
    print_header
    print_info "Installing all dependencies..."

    npm install
    cd backend && npm install
    cd ../frontend && npm install
    cd ..

    print_success "All dependencies installed!"
}

build_all() {
    print_header
    print_info "Building all projects..."

    npm run build

    print_success "Build completed!"
}

show_help() {
    print_header
    echo "Usage: ./dev.sh [command]"
    echo ""
    echo "Commands:"
    echo "  start       - Start all development servers"
    echo "  stop        - Stop all development servers"
    echo "  restart     - Restart all servers"
    echo "  status      - Check server status"
    echo "  install     - Install all dependencies"
    echo "  build       - Build all projects"
    echo "  logs        - Show application logs"
    echo "  help        - Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./dev.sh start"
    echo "  ./dev.sh status"
    echo "  ./dev.sh restart"
    echo ""
}

# Main
case "${1:-help}" in
    start)
        start_all
        ;;
    stop)
        stop_all
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    install)
        install_deps
        ;;
    build)
        build_all
        ;;
    logs)
        logs
        ;;
    help|*)
        show_help
        ;;
esac
