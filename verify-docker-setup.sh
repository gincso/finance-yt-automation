#!/bin/sh

# Docker Setup Verification Script
# Checks all components: Docker, Hermes, FFmpeg, and project files

echo "=========================================="
echo "Docker Setup Verification"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check Docker installation
echo "1. Checking Docker installation..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✓${NC} Docker: $DOCKER_VERSION"
else
    echo -e "${RED}✗${NC} Docker not found"
    exit 1
fi

# Check Docker Compose
echo ""
echo "2. Checking Docker Compose..."
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    echo -e "${GREEN}✓${NC} Docker Compose: $COMPOSE_VERSION"
else
    echo -e "${RED}✗${NC} Docker Compose not found"
    exit 1
fi

# Check Hermes
echo ""
echo "3. Checking Hermes installation..."
HERMES_DIR="/data/data/com.termux/files/home/.hermes"
if [ -d "$HERMES_DIR" ]; then
    echo -e "${GREEN}✓${NC} Hermes directory: $HERMES_DIR"
    echo -e "  Skills: $(ls -1 $HERMES_DIR/skills | wc -l)"
    echo -e "  Memories: $(ls -1 $HERMES_DIR/memories | wc -l)"
    echo -e "  Config: $(test -f $HERMES_DIR/config.yaml && echo '✓' || echo '✗')"
    echo -e "  Cron jobs: $(ls -1 $HERMES_DIR/cron | wc -l)"
else
    echo -e "${YELLOW}⚠${NC} Hermes directory not found: $HERMES_DIR"
    echo -e "  Container will run without Hermes"
fi

# Check FFmpeg
echo ""
echo "4. Checking FFmpeg installation..."
if command -v ffmpeg &> /dev/null; then
    FFMPEG_VERSION=$(ffmpeg -version | head -n1)
    echo -e "${GREEN}✓${NC} FFmpeg: $FFMPEG_VERSION"
else
    echo -e "${YELLOW}⚠${NC} FFmpeg not found on host"
    echo -e "  FFmpeg will be installed inside container"
fi

# Check Project Files
echo ""
echo "5. Checking project files..."
PROJECT_DIR="/data/data/com.termux/files/home/finance-yt-automation"

FILES=(
    "Dockerfile"
    "docker-compose.yml"
    "docker-build.sh"
    "quick-start.sh"
    "requirements.txt"
    ".dockerignore"
    "scripts/orchestrator.py"
    "scripts/generate_content.py"
    "scripts/create_video.py"
    "scripts/upload_youtube.py"
    "content/topics.py"
    "config/config.yaml"
)

ALL_PRESENT=true
for file in "${FILES[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file (missing)"
        ALL_PRESENT=false
    fi
done

if [ "$ALL_PRESENT" = false ]; then
    echo ""
    echo -e "${YELLOW}⚠${NC} Some files are missing"
fi

# Check Directories
echo ""
echo "6. Checking directory structure..."
DIRS=(
    "config"
    "scripts"
    "content"
    "models"
    "output"
    "logs"
)

for dir in "${DIRS[@]}"; do
    if [ -d "$PROJECT_DIR/$dir" ]; then
        echo -e "${GREEN}✓${NC} $dir/"
    else
        echo -e "${RED}✗${NC} $dir/ (missing)"
    fi
done

# Check Dockerfile content
echo ""
echo "7. Checking Dockerfile..."
if grep -q "FROM alpine" "$PROJECT_DIR/Dockerfile"; then
    echo -e "${GREEN}✓${NC} Alpine Linux base image"
fi
if grep -q "ffmpeg" "$PROJECT_DIR/Dockerfile"; then
    echo -e "${GREEN}✓${NC} FFmpeg included"
fi
if grep -q "hermes" "$PROJECT_DIR/Dockerfile"; then
    echo -e "${GREEN}✓${NC} Hermes instructions"
fi

# Check docker-compose.yml
echo ""
echo "8. Checking docker-compose.yml..."
if grep -q "finance-yt-automation" "$PROJECT_DIR/docker-compose.yml"; then
    echo -e "${GREEN}✓${NC} Service defined"
fi
if grep -q "volumes:" "$PROJECT_DIR/docker-compose.yml"; then
    echo -e "${GREEN}✓${NC} Volumes configured"
fi
if grep -q ".hermes" "$PROJECT_DIR/docker-compose.yml"; then
    echo -e "${GREEN}✓${NC} Hermes volume mounted"
fi
if grep -q "healthcheck:" "$PROJECT_DIR/docker-compose.yml"; then
    echo -e "${GREEN}✓${NC} Health checks enabled"
fi

# Check requirements.txt
echo ""
echo "9. Checking requirements.txt..."
if grep -q "requests" "$PROJECT_DIR/requirements.txt"; then
    echo -e "${GREEN}✓${NC} requests dependency"
fi
if grep -q "pyyaml" "$PROJECT_DIR/requirements.txt"; then
    echo -e "${GREEN}✓${NC} pyyaml dependency"
fi
if grep -q "python-dateutil" "$PROJECT_DIR/requirements.txt"; then
    echo -e "${GREEN}✓${NC} python-dateutil dependency"
fi
if grep -q "ffmpeg-python" "$PROJECT_DIR/requirements.txt"; then
    echo -e "${GREEN}✓${NC} ffmpeg-python dependency"
fi

# Check .dockerignore
echo ""
echo "10. Checking .dockerignore..."
if [ -f "$PROJECT_DIR/.dockerignore" ]; then
    echo -e "${GREEN}✓${NC} .dockerignore present"
    if grep -q ".hermes" "$PROJECT_DIR/.dockerignore"; then
        echo -e "${YELLOW}⚠${NC} .dockerignore excludes .hermes (should include)"
    fi
else
    echo -e "${RED}✗${NC} .dockerignore missing"
fi

# Summary
echo ""
echo "=========================================="
echo "Verification Summary"
echo "=========================================="
echo ""

# Count checks
TOTAL=0
PASSED=0

# Docker
TOTAL=$((TOTAL + 2))
if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
    PASSED=$((PASSED + 2))
fi

# Hermes
TOTAL=$((TOTAL + 5))
if [ -d "$HERMES_DIR" ]; then
    PASSED=$((PASSED + 5))
fi

# FFmpeg
TOTAL=$((TOTAL + 1))
if command -v ffmpeg &> /dev/null; then
    PASSED=$((PASSED + 1))
fi

# Project files
TOTAL=$((TOTAL + 11))
ALL_PRESENT=true
for file in "${FILES[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        PASSED=$((PASSED + 1))
    else
        ALL_PRESENT=false
    fi
done

# Directories
TOTAL=$((TOTAL + 6))
for dir in "${DIRS[@]}"; do
    if [ -d "$PROJECT_DIR/$dir" ]; then
        PASSED=$((PASSED + 1))
    fi
done

# Dockerfile
TOTAL=$((TOTAL + 3))
if grep -q "FROM alpine" "$PROJECT_DIR/Dockerfile"; then PASSED=$((PASSED + 1))
if grep -q "ffmpeg" "$PROJECT_DIR/Dockerfile"; then PASSED=$((PASSED + 1))
if grep -q "hermes" "$PROJECT_DIR/Dockerfile"; then PASSED=$((PASSED + 1))
fi

# docker-compose.yml
TOTAL=$((TOTAL + 4))
if grep -q "finance-yt-automation" "$PROJECT_DIR/docker-compose.yml"; then PASSED=$((PASSED + 1))
if grep -q "volumes:" "$PROJECT_DIR/docker-compose.yml"; then PASSED=$((PASSED + 1))
if grep -q ".hermes" "$PROJECT_DIR/docker-compose.yml"; then PASSED=$((PASSED + 1))
if grep -q "healthcheck:" "$PROJECT_DIR/docker-compose.yml"; then PASSED=$((PASSED + 1))
fi

# requirements.txt
TOTAL=$((TOTAL + 4))
if grep -q "requests" "$PROJECT_DIR/requirements.txt"; then PASSED=$((PASSED + 1))
if grep -q "pyyaml" "$PROJECT_DIR/requirements.txt"; then PASSED=$((PASSED + 1))
if grep -q "python-dateutil" "$PROJECT_DIR/requirements.txt"; then PASSED=$((PASSED + 1))
if grep -q "ffmpeg-python" "$PROJECT_DIR/requirements.txt"; then PASSED=$((PASSED + 1))
fi

# .dockerignore
TOTAL=$((TOTAL + 2))
if [ -f "$PROJECT_DIR/.dockerignore" ]; then
    PASSED=$((PASSED + 1))
fi

echo "Total Checks: $PASSED / $TOTAL"
echo ""

if [ $PASSED -eq $TOTAL ]; then
    echo -e "${GREEN}✓ All checks passed! Setup is complete and ready to use.${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Build the image: docker-compose build"
    echo "  2. Start the container: docker-compose up -d"
    echo "  3. Create a video: docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --single"
    echo ""
    echo "Or use the helper script:"
    echo "  ./quick-start.sh"
else
    echo -e "${YELLOW}⚠ Some checks failed. Please review the output above.${NC}"
    echo ""
    echo "Common fixes:"
    echo "  1. Install Docker and Docker Compose"
    echo "  2. Ensure Hermes is installed at ~/.hermes"
    echo "  3. Check all required files are present"
fi

echo ""
echo "=========================================="
