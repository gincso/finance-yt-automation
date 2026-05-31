# Docker Deployment Guide

This guide provides comprehensive instructions for deploying the Finance YouTube Automation system using Docker and Docker Compose.

## Quick Start

### Prerequisites

- Docker (20.10+)
- Docker Compose (2.0+)

### 1. Clone and Setup

```bash
cd ~/finance-yt-automation
cp .env.example .env
# Edit .env and add your API tokens
nano .env
```

### 2. Build and Run

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Run a single video creation
docker-compose run --rm finance-yt-automation python3 main.py
```

### 3. Check Status

```bash
# Check all containers
docker-compose ps

# Check container health
docker inspect --format='{{.State.Health.Status}}' finance-yt-automation

# View logs
docker-compose logs -f finance-yt-automation
```

## Configuration

### Environment Variables

The `.env` file controls all configuration:

- **HUGGINGFACE_API_TOKEN**: Required for LLM API calls
- **YOUTUBE_CLIENT_ID**: YouTube OAuth client ID
- **YOUTUBE_CLIENT_SECRET**: YouTube OAuth client secret
- **YOUTUBE_REFRESH_TOKEN**: YouTube refresh token
- **TZ**: Timezone setting
- **LOG_LEVEL**: Logging verbosity

### Volume Mappings

- `./config:/app/config:ro` - Configuration files (read-only)
- `./data:/app/data` - Data directories (persisted)
- `./logs:/app/logs` - Log files (persisted)
- `./output:/app/output` - Generated videos (persisted)

## Services

### Main Service: finance-yt-automation

The main automation service that:
- Runs the multi-agent system
- Creates videos using LLMs
- Optionally uploads to YouTube
- Logs all activities

**Resource Limits:**
- CPU: Up to 2 cores
- Memory: Up to 2GB

### Optional Services

#### Redis (Caching)

For future caching and performance optimization:

```bash
docker-compose up -d redis
```

#### PostgreSQL (Database)

For future database needs:

```bash
docker-compose up -d postgres
```

## Usage

### Run Automation Once

```bash
docker-compose run --rm finance-yt-automation python3 main.py
```

### Run in Background

```bash
docker-compose up -d
```

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f finance-yt-automation

# Last 100 lines
docker-compose logs --tail=100 finance-yt-automation
```

### Stop Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (data will be lost)
docker-compose down -v
```

### Restart Services

```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart finance-yt-automation
```

## Health Checks

The system includes automatic health checks:

```bash
# Check container health
docker inspect --format='{{.State.Health.Status}}' finance-yt-automation

# View health check logs
docker inspect --format='{{range .State.Health.Log}}{{.Output}}{{end}}' finance-yt-automation
```

## Monitoring

### Resource Usage

```bash
# Container stats
docker stats finance-yt-automation

# Docker system stats
docker system df
```

### Log Management

Logs are automatically rotated:
- Max size: 10MB per file
- Max files: 3 (keeps 30MB total)

## Troubleshooting

### Common Issues

**1. Permission Denied**

```bash
# Fix directory permissions
chmod -R 755 ./data ./logs ./output
```

**2. API Token Issues**

```bash
# Check environment variables
docker-compose exec finance-yt-automation env | grep HUGGINGFACE

# Verify token format
docker-compose exec finance-yt-automation python3 -c "from huggingface_hub import login; login()"
```

**3. Out of Memory**

```bash
# Edit docker-compose.yml and increase memory limit
# Restart service
docker-compose up -d --force-recreate finance-yt-automation
```

**4. Container Won't Start**

```bash
# Check logs
docker-compose logs finance-yt-automation

# Rebuild container
docker-compose build --no-cache
docker-compose up -d
```

## Advanced Configuration

### Custom Resource Limits

Edit `docker-compose.yml` to adjust:

```yaml
deploy:
  resources:
    limits:
      cpus: '4'  # Increase to 4 cores
      memory: 4G  # Increase to 4GB
```

### Custom Log Levels

In `.env`:

```bash
LOG_LEVEL=DEBUG  # Verbose logging
# or
LOG_LEVEL=WARNING  # Minimal logging
```

### Network Configuration

The default network is `yt-automation-network` with subnet `172.20.0.0/16`.

To connect external services:

```yaml
networks:
  yt-automation-network:
    external: true
```

## Production Deployment

### 1. Security Best Practices

- Use strong API tokens
- Keep `.env` file secure (add to `.gitignore`)
- Enable Docker content trust
- Use non-root user in container

### 2. Monitoring Setup

```bash
# Set up log aggregation
docker-compose logs -f finance-yt-automation | tee logs/automation.log
```

### 3. Backup Strategy

```bash
# Backup data volumes
docker run --rm -v finance-yt-automation-data:/data -v $(pwd):/backup alpine tar czf /backup/data-backup.tar.gz /data

# Backup configuration
cp .env .env.backup
```

### 4. Update Strategy

```bash
# Pull latest changes
git pull origin finance-yt-automation

# Rebuild and restart
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Maintenance

### Regular Tasks

```bash
# Clean up old logs
docker-compose exec finance-yt-automation find /app/logs -name "*.log" -mtime +7 -delete

# Clean up Docker system
docker system prune -a --volumes

# Check for updates
docker-compose pull
```

### Monitoring Schedule

- Daily: Check container health
- Weekly: Review logs and performance
- Monthly: Backup data volumes
- Quarterly: Update dependencies and images

## Support

For issues or questions:
1. Check logs: `docker-compose logs -f`
2. Review troubleshooting section
3. Check GitHub issues

## License

See LICENSE file for details.
