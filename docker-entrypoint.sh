#!/bin/sh
# Docker entrypoint script

set -e

echo "=========================================="
echo "Finance YouTube Automation - Docker"
echo "=========================================="
echo ""

# Create necessary directories if they don't exist
mkdir -p /app/data/videos
mkdir -p /app/data/scripts
mkdir -p /app/data/audio
mkdir -p /app/data/thumbnails
mkdir -p /app/data/uploads
mkdir -p /app/logs

echo "✓ Directories created"

# Check if config exists
if [ ! -f "/app/config/config.yaml" ]; then
    echo "⚠ Warning: config/config.yaml not found"
    echo "  Create it with your API keys and settings"
    echo ""
fi

# Check if Hugging Face token is configured
if [ -z "$HUGGINGFACE_API_TOKEN" ]; then
    echo "⚠ Warning: HUGGINGFACE_API_TOKEN not set"
    echo "  The automation will use mock data"
    echo "  Get a free token at: https://huggingface.co/settings/tokens"
    echo ""
fi

# Check if YouTube credentials are configured
if [ -z "$YOUTUBE_CLIENT_ID" ] || [ -z "$YOUTUBE_CLIENT_SECRET" ]; then
    echo "⚠ Warning: YouTube credentials not set"
    echo "  Upload functionality will not work"
    echo ""
fi

# Display configuration status
echo "Configuration Status:"
echo "  Hugging Face API: ${HUGGINGFACE_API_TOKEN:+Configured}"
echo "  YouTube API: ${YOUTUBE_CLIENT_ID:+Configured}"
echo "  Timezone: $TZ"
echo ""

# Run the main script
echo "Starting automation..."
echo "=========================================="
echo ""

python3 main.py

echo ""
echo "=========================================="
echo "Automation complete!"
echo "=========================================="

# Keep container running for monitoring
# Uncomment the line below if you want the container to stay alive
# exec tail -f /dev/null
