#!/bin/sh

# Quick Start Script for Finance YouTube Automation Docker

echo "======================================"
echo "Finance YouTube Automation - Quick Start"
echo "======================================"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker first."
    exit 1
fi

echo "Docker is running ✓"
echo ""

# Build the image
echo "Building Docker image..."
docker-compose build

if [ $? -ne 0 ]; then
    echo "Error: Failed to build image"
    exit 1
fi

echo "Image built successfully ✓"
echo ""

# Run a single video
echo "Creating your first video..."
docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --single

echo ""
echo "======================================"
echo "Video created successfully!"
echo "Check the logs for details:"
echo "  docker-compose logs -f"
echo "======================================"
