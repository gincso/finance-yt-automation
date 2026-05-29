#!/bin/bash
# Finance YouTube Channel Automation - Setup Script

set -e

echo "=========================================="
echo "Finance YouTube Channel - Setup"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Project directory
PROJECT_DIR="$HOME/finance-yt-automation"
echo -e "${GREEN}Project directory: $PROJECT_DIR${NC}"

# Create directory structure
echo ""
echo "Creating directory structure..."
mkdir -p "$PROJECT_DIR/scripts"
mkdir -p "$PROJECT_DIR/content/templates"
mkdir -p "$PROJECT_DIR/content/scripts"
mkdir -p "$PROJECT_DIR/models"
mkdir -p "$PROJECT_DIR/output/videos"
mkdir -p "$PROJECT_DIR/output/metadata"
mkdir -p "$PROJECT_DIR/logs"
mkdir -p "$PROJECT_DIR/config"

echo -e "${GREEN}✓ Directory structure created${NC}"

# Check Python
echo ""
echo "Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}✓ Python found: $PYTHON_VERSION${NC}"
else
    echo -e "${RED}✗ Python not found. Please install Python 3.8+${NC}"
    exit 1
fi

# Install Python dependencies
echo ""
echo "Installing Python dependencies..."
pip3 install -q requests pyyaml python-dateutil

echo -e "${GREEN}✓ Dependencies installed${NC}"

# Check FFmpeg (for video processing)
echo ""
echo "Checking FFmpeg installation..."
if command -v ffmpeg &> /dev/null; then
    FFmpeg_VERSION=$(ffmpeg -version | head -n1)
    echo -e "${GREEN}✓ FFmpeg found: $FFmpeg_VERSION${NC}"
else
    echo -e "${YELLOW}⚠ FFmpeg not found. Install with: pkg install ffmpeg${NC}"
    echo "  (Optional - for advanced video processing)"
fi

# Setup Hugging Face token
echo ""
echo "Hugging Face API Configuration"
echo "================================"
echo "Get your free API token from: https://huggingface.co/settings/tokens"
echo ""
read -p "Enter your Hugging Face token (or press Enter to skip): " HF_TOKEN

if [ ! -z "$HF_TOKEN" ]; then
    echo "$HF_TOKEN" > "$PROJECT_DIR/.env"
    echo -e "${GREEN}✓ Hugging Face token saved${NC}"
else
    echo -e "${YELLOW}⚠ Skipping Hugging Face token setup${NC}"
    echo "  You can set it later with: export HUGGINGFACE_TOKEN=\"your_token\""
fi

# Setup YouTube API (optional)
echo ""
echo "YouTube API Configuration (Optional)"
echo "====================================="
echo "Get your API key from: https://console.cloud.google.com/apis/credentials"
echo ""
read -p "Enter your YouTube API key (or press Enter to skip): " YOUTUBE_KEY

if [ ! -z "$YOUTUBE_KEY" ]; then
    echo "$YOUTUBE_KEY" > "$PROJECT_DIR/.youtube_env"
    echo -e "${GREEN}✓ YouTube API key saved${NC}"
else
    echo -e "${YELLOW}⚠ Skipping YouTube API setup${NC}"
    echo "  You can set it later with: export YOUTUBE_API_KEY=\"your_key\""
fi

# Create sample configuration
echo ""
echo "Creating sample configuration..."
cat > "$PROJECT_DIR/config/config.yaml" << 'EOF'
# Finance YouTube Channel Automation Configuration

# Content Strategy
content_strategy:
  channel_name: "Wealth Wisdom"
  channel_description: "Automated finance insights and market analysis"
  target_audience: "Beginners to intermediate investors"

# AI Models Configuration
ai_models:
  llm:
    provider: "huggingface"
    model: "meta-llama/Llama-3.2-3B-Instruct"
    api_base: "https://api-inference.huggingface.co/models/meta-llama/Llama-3.2-3B-Instruct"
    max_tokens: 500
    temperature: 0.7

# Content Generation Settings
content_generation:
  daily_videos: 2
  weekly_videos: 14
  topics_per_video: 3

# Video Creation Settings
video_creation:
  template_style: "clean_minimal"
  background_music:
    enabled: true
    volume: 0.3
  voiceover:
    enabled: true
    model: "openai-whisper-small"
  subtitles:
    enabled: true

# Automation Settings
automation:
  schedule:
    videos_per_day: 2
    upload_time: "09:00"
  
  agents:
    - name: "content_researcher"
      role: "Researches trending finance topics"
    
    - name: "content_writer"
      role: "Writes video scripts and descriptions"
    
    - name: "video_creator"
      role: "Creates videos from scripts"
    
    - name: "uploader"
      role: "Uploads videos to YouTube"
EOF

echo -e "${GREEN}✓ Configuration file created${NC}"

# Make scripts executable
echo ""
echo "Making scripts executable..."
chmod +x "$PROJECT_DIR/scripts"/*.py

echo -e "${GREEN}✓ Scripts made executable${NC}"

# Test the setup
echo ""
echo "Testing the setup..."
cd "$PROJECT_DIR"
python3 scripts/generate_content.py > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Setup test successful${NC}"
else
    echo -e "${RED}✗ Setup test failed${NC}"
    exit 1
fi

# Summary
echo ""
echo "=========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "=========================================="
echo ""
echo "Project directory: $PROJECT_DIR"
echo ""
echo "Quick start:"
echo "  python3 scripts/orchestrator.py --single"
echo ""
echo "Create multiple videos:"
echo "  python3 scripts/orchestrator.py --batch 5"
echo ""
echo "Run in continuous mode:"
echo "  python3 scripts/orchestrator.py --continuous"
echo ""
echo "For more information, see: README.md"
echo ""
