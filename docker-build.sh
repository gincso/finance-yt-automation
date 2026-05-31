#!/bin/sh

# Finance YouTube Automation - Docker Build Script with Hermes
# This script builds and runs the Docker container with Hermes and all required files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        print_info "Visit: https://docs.docker.com/get-docker/"
        exit 1
    fi
    print_info "Docker is installed: $(docker --version)"
}

# Check if Docker Compose is installed
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        print_info "Visit: https://docs.docker.com/compose/install/"
        exit 1
    fi
    print_info "Docker Compose is installed: $(docker-compose --version)"
}

# Check if Hermes is available on host
check_hermes() {
    HERMES_DIR="/data/data/com.termux/files/home/.hermes"
    if [ -d "$HERMES_DIR" ]; then
        print_info "Hermes found at: $HERMES_DIR"
        print_info "Hermes will be mounted into container"
    else
        print_warn "Hermes directory not found: $HERMES_DIR"
        print_warn "Container will run without Hermes"
    fi
}

# Check if FFmpeg is installed
check_ffmpeg() {
    if command -v ffmpeg &> /dev/null; then
        FFmpeg_VERSION=$(ffmpeg -version | head -n1)
        print_info "FFmpeg is installed: $FFmpeg_VERSION"
    else
        print_warn "FFmpeg not found on host"
        print_info "FFmpeg will be installed inside container"
    fi
}

# Build the Docker image
build_image() {
    print_header "Building Docker Image"

    print_info "This may take a few minutes..."

    docker-compose build --no-cache

    if [ $? -eq 0 ]; then
        print_info "Docker image built successfully!"
    else
        print_error "Failed to build image"
        exit 1
    fi
}

# Run the container
run_container() {
    print_header "Starting Container"

    print_info "Starting Docker container..."
    docker-compose up -d

    if [ $? -eq 0 ]; then
        print_info "Container is running!"
        print_info "View logs: docker-compose logs -f"
    else
        print_error "Failed to start container"
        exit 1
    fi
}

# Stop the container
stop_container() {
    print_info "Stopping Docker container..."
    docker-compose down
    print_info "Container stopped!"
}

# Run a single video
run_single() {
    print_header "Creating Single Video"
    print_info "This will use Hermes and FFmpeg if available..."

    docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --single
}

# Run batch processing
run_batch() {
    print_header "Batch Processing"
    print_info "Creating 5 videos..."

    docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --batch 5
}

# Run continuous mode
run_continuous() {
    print_header "Continuous Mode"
    print_info "Running in continuous automation mode..."

    docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --continuous
}

# Show help
show_help() {
    cat << EOF
Finance YouTube Automation - Docker Helper Script with Hermes

Usage: $0 [COMMAND]

Commands:
    build          Build the Docker image (includes Hermes and FFmpeg)
    up             Start the container (continuous mode)
    down           Stop and remove the container
    restart        Restart the container
    single         Run a single video creation
    batch          Run batch processing (5 videos)
    continuous     Run in continuous mode
    logs           View container logs
    status         Check container status
    shell          Enter container shell
    hermes         Check Hermes status
    ffmpeg         Check FFmpeg status
    help           Show this help message

Features:
    - Includes Hermes from host system
    - Includes FFmpeg for video processing
    - Mounts all required files and directories
    - Automatic resource management
    - Health checks enabled

Environment Variables:
    HUGGINGFACE_TOKEN     Hugging Face API token
    YOUTUBE_API_KEY       YouTube API key (optional)

Volume Mounts:
    - ./config           Configuration files
    - ./scripts          Python scripts
    - ./content          Content topics
    - ./models           AI models
    - ./output           Generated content
    - /path/to/.hermes   Hermes installation
    - ./logs             Execution logs
    - ./.env             Environment variables
    - ./.youtube_env     YouTube API key

Examples:
    $0 build              # Build image with Hermes and FFmpeg
    $0 up                 # Start container
    $0 single             # Create one video
    $0 batch              # Create 5 videos
    $0 logs               # View logs
    $0 shell              # Enter container
    $0 hermes             # Check Hermes
    $0 ffmpeg             # Check FFmpeg

EOF
}

# Main script
main() {
    # Check Docker installation
    check_docker
    check_docker_compose

    # Check Hermes and FFmpeg
    check_hermes
    check_ffmpeg

    # Parse command
    case "${1:-help}" in
        build)
            build_image
            ;;
        up)
            run_container
            ;;
        down)
            stop_container
            ;;
        restart)
            stop_container
            build_image
            run_container
            ;;
        single)
            run_single
            ;;
        batch)
            run_batch
            ;;
        continuous)
            run_continuous
            ;;
        logs)
            docker-compose logs -f
            ;;
        status)
            docker-compose ps
            ;;
        shell)
            docker-compose exec finance-yt-automation sh
            ;;
        hermes)
            print_info "Hermes Status:"
            docker-compose exec finance-yt-automation ls -la /root/.hermes || echo "Hermes not accessible in container"
            ;;
        ffmpeg)
            print_info "FFmpeg Status:"
            docker-compose exec finance-yt-automation ffmpeg -version | head -n1 || echo "FFmpeg not accessible in container"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
