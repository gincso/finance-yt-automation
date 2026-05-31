#!/bin/bash
# Setup script for Finance YouTube Automation

echo "=========================================="
echo "Finance YouTube Automation - Setup"
echo "=========================================="
echo ""

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Installing..."
    pkg install python -y
fi

# Check pip
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 not found. Installing..."
    pkg install python-pip -y
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
pip3 install -r requirements.txt

# Create necessary directories
echo ""
echo "📁 Creating directories..."
mkdir -p data/videos
mkdir -p data/scripts
mkdir -p data/audio
mkdir -p data/thumbnails
mkdir -p data/uploads
mkdir -p logs

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit config/config.yaml and add your API keys"
echo "2. Run: python main.py"
echo "3. For daily automation, set up a cron job"
echo ""
