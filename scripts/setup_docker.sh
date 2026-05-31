#!/bin/bash
# Complete setup script for Docker

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
    echo -e "${RED}❌ Docker not found. Installing...${NC}"
    pkg install docker -y
    echo -e "${GREEN}✓ Docker installed${NC}"
else
    echo -e "${GREEN}✓ Docker is installed${NC}"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose not found. Installing...${NC}"
    pkg install docker-compose -y
    echo -e "${GREEN}✓ Docker Compose installed${NC}"
else
    echo -e "${GREEN}✓ Docker Compose is installed${NC}"
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo ""
    echo -e "${YELLOW}Creating .env file...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✓ .env file created${NC}"
    echo -e "${YELLOW}⚠ Edit .env and add your API keys${NC}"
else
    echo -e "${GREEN}✓ .env file already exists${NC}"
fi

# Create config file if it doesn't exist
if [ ! -f config/config.yaml ]; then
    echo ""
    echo -e "${YELLOW}Creating config file...${NC}"
    cp config/config.yaml.example config/config.yaml
    echo -e "${GREEN}✓ config.yaml created${NC}"
    echo -e "${YELLOW}⚠ Edit config/config.yaml with your settings${NC}"
else
    echo -e "${GREEN}✓ config.yaml already exists${NC}"
fi

# Make scripts executable
echo ""
echo -e "${YELLOW}Making scripts executable...${NC}"
chmod +x scripts/*.sh docker-entrypoint.sh Makefile 2>/dev/null || true
echo -e "${GREEN}✓ Scripts made executable${NC}"

# Build Docker image
echo ""
echo -e "${YELLOW}Building Docker image...${NC}"
make build
echo -e "${GREEN}✓ Docker image built${NC}"

# Ask if user wants to run once
echo ""
echo "=========================================="
echo "Setup complete! What would you like to do?"
echo "=========================================="
echo "1) Run once to test"
echo "2) Start container in background"
echo "3) Exit (do nothing)"
echo ""
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}Running automation once...${NC}"
        make test
        ;;
    2)
        echo ""
        echo -e "${YELLOW}Starting container in background...${NC}"
        make up-d
        echo -e "${GREEN}✓ Container started${NC}"
        echo ""
        echo "View logs with: make logs-f"
        echo "Stop with: make down"
        ;;
    3)
        echo ""
        echo "Setup complete. Run 'make build' and 'make test' when ready."
        ;;
    *)
        echo "Invalid choice. Setup complete."
        ;;
esac

echo ""
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit .env and add your API keys"
echo "2. Edit config/config.yaml with your settings"
echo "3. Run 'make test' to test"
echo "4. Run 'make cron-add' to set up daily automation"
echo "5. Run 'make logs-f' to monitor logs"
echo ""
