#!/bin/bash
# ==========================================
# Docker Quick Setup Script for Finance YT Automation
# ==========================================

set -e

echo "=========================================="
echo "Finance YouTube Automation - Docker Setup"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed${NC}"
    echo "Please install Docker Compose first"
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}Warning: .env file not found${NC}"
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo -e "${GREEN}✓ .env file created${NC}"
    echo ""
    echo -e "${YELLOW}IMPORTANT: Please edit .env and add your API tokens:${NC}"
    echo "  - HUGGINGFACE_API_TOKEN"
    echo "  - YOUTUBE_CLIENT_ID"
    echo "  - YOUTUBE_CLIENT_SECRET"
    echo ""
    read -p "Press Enter to continue after editing .env..."
fi

# Create necessary directories
echo "Creating directories..."
mkdir -p data/{videos,scripts,audio,thumbnails,uploads}
mkdir -p logs
mkdir -p output
chmod -R 755 data logs output
echo -e "${GREEN}✓ Directories created${NC}"
echo ""

# Build and start services
echo "Building Docker images..."
docker-compose build
echo -e "${GREEN}✓ Docker images built${NC}"
echo ""

echo "Starting services..."
docker-compose up -d
echo -e "${GREEN}✓ Services started${NC}"
echo ""

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 5

# Check status
echo ""
echo "Service Status:"
docker-compose ps
echo ""

# Show logs
echo "Recent logs:"
echo "=========================================="
docker-compose logs --tail=20 finance-yt-automation
echo "=========================================="
echo ""

# Test run
echo "Testing automation..."
docker-compose run --rm finance-yt-automation python3 main.py
echo ""

echo "=========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "=========================================="
echo ""
echo "Useful commands:"
echo "  View logs:       docker-compose logs -f"
echo "  Stop services:   docker-compose down"
echo "  Restart:         docker-compose restart"
echo "  Check status:    docker-compose ps"
echo ""
echo "Your automation is now running!"
