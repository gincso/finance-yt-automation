#!/bin/bash
# YouTube Video Upload Script
# Uploads generated videos to YouTube

set -e

PROJECT_DIR="$HOME/finance-yt-automation"
OUTPUT_DIR="$PROJECT_DIR/output/videos"

echo "=========================================="
echo "YouTube Video Upload Script"
echo "=========================================="

# Check if YouTube API key is set
if [ -z "$YOUTUBE_API_KEY" ]; then
    echo "⚠ YouTube API key not set"
    echo "  Get your API key from: https://console.cloud.google.com/apis/credentials"
    echo ""
    echo "Set it with: export YOUTUBE_API_KEY=\"your...t"
    exit 1
fi

# Find the latest video
echo "📁 Looking for latest video..."
LATEST_VIDEO=$(ls -t "$OUTPUT_DIR"/*.json 2>/dev/null | head -n1)

if [ -z "$LATEST_VIDEO" ]; then
    echo "⚠ No videos found in $OUTPUT_DIR"
    exit 1
fi

echo "✓ Found: $LATEST_VIDEO"

# Load video data
echo ""
echo "📄 Loading video data..."
python3 -c "
import json
import sys

with open('$LATEST_VIDEO', 'r') as f:
    data = json.load(f)

print(f\"Title: {data.get('title', 'N/A')}\")
print(f\"Category: {data.get('category', 'N/A')}\")
print(f\"Duration: {data.get('estimated_duration', 'N/A')}\")
print(f\"Keywords: {', '.join(data.get('keywords', [])[:3])}\")
"

# Note: Actual YouTube upload requires:
# 1. YouTube Data API v3 setup
# 2. OAuth 2.0 authentication
# 3. Video file creation
# 4. Upload script

echo ""
echo "=========================================="
echo "Video Prepared for Upload"
echo "=========================================="
echo ""
echo "To upload to YouTube, you need to:"
echo ""
echo "1. Create a video file from the script"
echo "2. Use the YouTube Data API v3 to upload"
echo ""
echo "For now, the script is saved at:"
echo "  $LATEST_VIDEO"
echo ""
echo "You can manually review and upload this content."
echo ""
echo "For automated YouTube upload, integrate with:"
echo "  - google-api-python-client"
echo "  - YouTube Data API v3"
echo "  - OAuth 2.0 authentication"
echo ""
echo "See README.md for detailed setup instructions."
