# Docker with Hermes and FFmpeg - Complete Setup

## Overview

This Docker setup includes:
- **Alpine Linux 3.19** - Lightweight base image
- **Python 3** with all dependencies
- **FFmpeg** - Video processing and encoding
- **Hermes** - Full Hermes agent installation from host system
- **All project files** - Config, scripts, content, models

## File Structure

```
finance-yt-automation/
├── Dockerfile                          # Docker configuration
├── docker-compose.yml                  # Docker Compose configuration
├── .dockerignore                       # Build context optimization
├── requirements.txt                    # Python dependencies
├── docker-build.sh                     # Helper script
├── quick-start.sh                      # Quick start script
├── DOCKER.md                           # Docker documentation
├── DOCKER_SETUP.md                     # Setup summary
├── DOCKER_WITH_HERMES.md              # This file
│
├── scripts/                            # Python scripts
│   ├── orchestrator.py                # Main orchestration
│   ├── generate_content.py            # Content generation
│   ├── create_video.py                # Video creation
│   └── upload_youtube.py              # YouTube upload
│
├── content/                            # Content topics
│   └── topics.py
│
├── models/                             # AI models cache
│
├── output/                             # Generated content (volume mount)
│   ├── videos/
│   ├── metadata/
│   └── scripts/
│
├── logs/                               # Execution logs (volume mount)
│
└── config/                             # Configuration (volume mount)
    └── config.yaml
```

## Docker Volume Mounts

The following directories are mounted from your host system:

### Project Files
- `./scripts` → `/app/scripts` - Python scripts
- `./content` → `/app/content` - Content topics
- `./models` → `/app/models` - AI models cache
- `./output` → `/app/output` - Generated content
- `./config` → `/app/config` - Configuration files

### Hermes Installation
- `/data/data/com.termux/files/home/.hermes` → `/root/.hermes` - Full Hermes installation

### Environment
- `./logs` → `/app/logs` - Execution logs
- `./.env` → `/app/.env` - Environment variables
- `./.youtube_env` → `/app/.youtube_env` - YouTube API key

## Quick Start

### Prerequisites

1. **Docker installed**
   ```bash
   # Check if Docker is installed
   docker --version
   docker-compose --version
   ```

2. **Hermes installed on host** (optional but recommended)
   ```bash
   # Check if Hermes is available
   ls -la ~/.hermes
   ```

3. **FFmpeg installed on host** (optional - will be installed in container)

### Build and Run

```bash
# Navigate to project directory
cd /data/data/com.termux/files/home/finance-yt-automation

# Make scripts executable
chmod +x docker-build.sh quick-start.sh

# Run quick start (builds image and creates first video)
./quick-start.sh
```

### Manual Build and Run

```bash
# Build the Docker image
docker-compose build

# Start the container
docker-compose up -d

# Check container status
docker-compose ps

# View logs
docker-compose logs -f

# Create a single video
docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --single

# Create multiple videos
docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --batch 5

# Run continuous mode
docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --continuous
```

## Using the Helper Script

```bash
# Build image
./docker-build.sh build

# Start container
./docker-build.sh up

# Create single video
./docker-build.sh single

# Create batch videos
./docker-build.sh batch

# Run continuous mode
./docker-build.sh continuous

# View logs
./docker-build.sh logs

# Check status
./docker-build.sh status

# Enter container shell
./docker-build.sh shell

# Check Hermes
./docker-build.sh hermes

# Check FFmpeg
./docker-build.sh ffmpeg

# Stop container
./docker-build.sh down

# Restart container
./docker-build.sh restart
```

## Configuration

### Environment Variables

Create a `.env` file in the project root:

```bash
# Hugging Face API Token (required for LLM)
HUGGINGFACE_TOKEN=hf_XXXXXXXXXXXXXXXXXXXXXXXX

# YouTube API Key (optional - for uploads)
YOUTUBE_API_KEY=AIzaXXXXXXXXXXXXXXXXXXXXXXXX

# Timezone
TZ=UTC
```

### Configuration File

Edit `config/config.yaml` to customize:

```yaml
content_strategy:
  channel_name: "Wealth Wisdom"
  target_audience: "Beginners to intermediate investors"

ai_models:
  llm:
    provider: huggingface
    model: meta-llama/Llama-3.2-3B-Instruct
    api_base: https://api-inference.huggingface.co/models/meta-llama/Llama-3.2-3B-Instruct
    max_tokens: 500
    temperature: 0.7

video_creation:
  template_style: clean_minimal
  background_music:
    enabled: true
    volume: 0.3
  voiceover:
    enabled: true
    model: openai-whisper-small
  subtitles:
    enabled: true

automation:
  schedule:
    videos_per_day: 2
    upload_time: "09:00"
```

## Hermes Integration

### What's Included

The Docker container includes a complete Hermes installation from your host system:

- **Skills** - All your skills are available
- **Memories** - Persistent memory is accessible
- **Config** - Hermes configuration is mounted
- **Cron Jobs** - Scheduled tasks are preserved
- **Logs** - Hermes logs are accessible
- **Models** - AI model cache is available

### Access Hermes in Container

```bash
# Enter container shell
docker-compose exec finance-yt-automation sh

# Check Hermes directory
ls -la /root/.hermes

# Check Hermes skills
ls -la /root/.hermes/skills/

# Run Hermes commands
hermes --help
```

### Using Hermes in Python Scripts

Your scripts can now use Hermes:

```python
from hermes_tools import memory, skills_list

# Access memory
memory.add(action="add", target="memory", content="Test memory")

# List skills
skills = skills_list()
print(skills)
```

### Using Hermes Skills

```bash
# List available skills
docker-compose exec finance-yt-automation python3 -c "from hermes_tools import skills_list; print(skills_list())"

# Use a skill
docker-compose exec finance-yt-automation python3 -c "
from hermes_tools import skill_view
skill_view(name='your-skill-name')
"
```

## FFmpeg Integration

### What's Included

FFmpeg is installed in the container for video processing:

```bash
# Check FFmpeg version
docker-compose exec finance-yt-automation ffmpeg -version

# Check FFmpeg capabilities
docker-compose exec finance-yt-automation ffmpeg -formats
docker-compose exec finance-yt-automation ffmpeg -codecs
```

### Using FFmpeg in Scripts

```python
import subprocess

# Video encoding example
subprocess.run([
    'ffmpeg',
    '-i', 'input.mp4',
    '-c:v', 'libx264',
    '-preset', 'fast',
    '-crf', '23',
    'output.mp4'
])
```

### Video Processing

The container can handle:
- Video encoding and transcoding
- Audio processing
- Image manipulation
- Video editing
- Format conversion

## Project Files in Container

### All Scripts Available

```bash
# List all scripts
docker-compose exec finance-yt-automation ls -la /app/scripts/

# Execute any script
docker-compose exec finance-yt-automation python3 scripts/orchestrator.py --single
docker-compose exec finance-yt-automation python3 scripts/generate_content.py
docker-compose exec finance-yt-automation python3 scripts/create_video.py
docker-compose exec finance-yt-automation python3 scripts/upload_youtube.py
```

### Content Topics

```bash
# View content topics
docker-compose exec finance-yt-automation cat /app/content/topics.py
```

### Models Directory

```bash
# Check models directory
docker-compose exec finance-yt-automation ls -la /app/models/
```

## Resource Management

### Container Resource Limits

The container has resource limits configured:

```yaml
deploy:
  resources:
    limits:
      cpus: '2'
      memory: 2G
    reservations:
      cpus: '1'
      memory: 1G
```

### Adjust Limits

Edit `docker-compose.yml` to adjust:

```yaml
# Increase limits for more videos
limits:
  cpus: '4'
  memory: 4G

# Decrease for limited resources
limits:
  cpus: '1'
  memory: 1G
```

### Monitor Resources

```bash
# Check container status
docker stats finance-yt-automation

# Check container resources
docker-compose exec finance-yt-automation free -h
docker-compose exec finance-yt-automation nproc
```

## Health Checks

The container includes health checks:

```yaml
healthcheck:
  test: ["CMD", "python3", "-c", "import sys; sys.exit(0)"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### Check Health

```bash
# Check container health
docker-compose ps

# View health status
docker inspect finance-yt-automation | grep -A 10 Health
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker-compose logs

# Rebuild without cache
docker-compose build --no-cache
docker-compose up -d

# Check container status
docker-compose ps
```

### Hermes Not Working

```bash
# Check Hermes mount
docker-compose exec finance-yt-automation ls -la /root/.hermes

# Check Hermes config
docker-compose exec finance-yt-automation cat /root/.hermes/config.yaml

# Check Hermes skills
docker-compose exec finance-yt-automation ls -la /root/.hermes/skills/
```

### FFmpeg Not Working

```bash
# Check FFmpeg installation
docker-compose exec finance-yt-automation ffmpeg -version

# Reinstall FFmpeg
docker-compose exec finance-yt-automation apk add --no-cache ffmpeg
```

### Permission Issues

```bash
# Fix permissions on mounted volumes
chmod -R 777 ./logs ./output ./config

# Rebuild container
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Python Dependencies Issues

```bash
# Reinstall dependencies
docker-compose exec finance-yt-automation pip3 install --upgrade -r requirements.txt

# Rebuild container
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Common Workflows

### Create a Single Video

```bash
docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --single
```

### Create Multiple Videos

```bash
docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --batch 5
```

### Run Continuous Automation

```bash
docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --continuous
```

### Run in Background

```bash
# Run continuous mode in background
docker-compose run -d finance-yt-automation python3 scripts/orchestrator.py --continuous

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

### Schedule with Cron

```bash
# Add to crontab
crontab -e

# Add this line for daily video creation at 9 AM
0 9 * * * cd /path/to/project && docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --continuous
```

## Backup and Restore

### Backup Volume Data

```bash
# Backup logs
tar -czf logs-backup-$(date +%Y%m%d).tar.gz ./logs

# Backup output
tar -czf output-backup-$(date +%Y%m%d).tar.gz ./output

# Backup config
tar -czf config-backup-$(date +%Y%m%d).tar.gz ./config

# Backup Hermes
tar -czf hermes-backup-$(date +%Y%m%d).tar.gz ~/.hermes
```

### Restore Volume Data

```bash
# Restore logs
tar -xzf logs-backup-20250101.tar.gz -C ./

# Restore output
tar -xzf output-backup-20250101.tar.gz -C ./

# Restore config
tar -xzf config-backup-20250101.tar.gz -C ./
```

## Security Best Practices

1. **Never commit secrets** to the repository
2. **Use environment variables** for sensitive data
3. **Keep images updated** with `docker-compose pull`
4. **Scan images** for vulnerabilities using Trivy
5. **Use non-root users** in production containers
6. **Limit container privileges** with user namespaces

## Performance Optimization

### Build Cache

The Dockerfile uses layer caching:

```dockerfile
# Copy requirements first (changes rarely)
COPY requirements.txt .

# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy project files (changes frequently)
COPY . .
```

### Multi-stage Build (Optional)

For even smaller images, consider a multi-stage build:

```dockerfile
# Build stage
FROM alpine:3.19 as builder
# Install dependencies and build

# Runtime stage
FROM alpine:3.19
COPY --from=builder /app /app
```

## Production Deployment

### Docker Swarm

```bash
# Deploy stack
docker stack deploy -c docker-compose.yml finance-yt-automation

# Check services
docker stack services finance-yt-automation

# Scale services
docker service scale finance-yt-automation_finance-yt-automation=3
```

### Kubernetes

Create a `k8s/` directory with manifests:

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: finance-yt-automation
spec:
  replicas: 3
  selector:
    matchLabels:
      app: finance-yt-automation
  template:
    metadata:
      labels:
        app: finance-yt-automation
    spec:
      containers:
      - name: finance-yt-automation
        image: yourusername/finance-yt-automation:latest
        ports:
        - containerPort: 8080
        env:
        - name: HUGGINGFACE_TOKEN
          valueFrom:
            secretKeyRef:
              name: hermes-secrets
              key: hf-token
        volumeMounts:
        - name: hermes
          mountPath: /root/.hermes
      volumes:
      - name: hermes
        hostPath:
          path: /data/data/com.termux/files/home/.hermes
```

## Monitoring

### Container Logs

```bash
# View all logs
docker-compose logs

# View recent logs
docker-compose logs --tail=100

# Follow logs
docker-compose logs -f

# Filter logs
docker-compose logs | grep "ERROR"
```

### Metrics

```bash
# Container stats
docker stats finance-yt-automation

# CPU and memory usage
docker-compose exec finance-yt-automation free -h
docker-compose exec finance-yt-automation top -bn1 | head -n 10
```

## Support

### Getting Help

1. **Check logs**: `docker-compose logs`
2. **Check container status**: `docker-compose ps`
3. **Enter container**: `docker-compose exec finance-yt-automation sh`
4. **Review documentation**: See DOCKER.md and DOCKER_SETUP.md

### Common Issues

1. **Hermes not working**: Check if `.hermes` directory is mounted correctly
2. **FFmpeg not working**: Reinstall with `apk add --no-cache ffmpeg`
3. **Permission issues**: Fix with `chmod -R 777 ./logs ./output ./config`
4. **Container won't start**: Rebuild with `docker-compose build --no-cache`

## File Locations

- Dockerfile: `/data/data/com.termux/files/home/finance-yt-automation/Dockerfile`
- docker-compose.yml: `/data/data/com.termux/files/home/finance-yt-automation/docker-compose.yml`
- docker-build.sh: `/data/data/com.termux/files/home/finance-yt-automation/docker-build.sh`
- DOCKER.md: `/data/data/com.termux/files/home/finance-yt-automation/DOCKER.md`
- DOCKER_SETUP.md: `/data/data/com.termux/files/home/finance-yt-automation/DOCKER_SETUP.md`
- This file: `/data/data/com.termux/files/home/finance-yt-automation/DOCKER_WITH_HERMES.md`

## Quick Reference

```bash
# Build
docker-compose build

# Start
docker-compose up -d

# Create video
docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --single

# Batch
docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --batch 5

# Continuous
docker-compose run --rm finance-yt-automation python3 scripts/orchestrator.py --continuous

# Logs
docker-compose logs -f

# Status
docker-compose ps

# Hermes check
docker-compose exec finance-yt-automation ls -la /root/.hermes

# FFmpeg check
docker-compose exec finance-yt-automation ffmpeg -version

# Shell
docker-compose exec finance-yt-automation sh

# Stop
docker-compose down
```

---

**Status**: Docker with Hermes and FFmpeg setup complete!
**Includes**: Alpine Linux 3.19, Python 3, FFmpeg, Full Hermes installation, All project files
**Ready for**: Production deployment with minimal human intervention
