# Docker Troubleshooting Guide

This guide helps you resolve common issues with the Finance YouTube Automation Docker setup.

## Table of Contents

1. [Common Issues](#common-issues)
2. [Container Won't Start](#container-wont-start)
3. [Permission Issues](#permission-issues)
4. [API Token Problems](#api-token-problems)
5. [Performance Issues](#performance-issues)
6. [Volume Mount Issues](#volume-mount-issues)
7. [Network Issues](#network-issues)
8. [Log Issues](#log-issues)

---

## Common Issues

### Issue: Docker Compose command not found

**Symptoms:**
```
docker-compose: command not found
```

**Solution:**
```bash
# Install Docker Compose
# On Linux:
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version
```

### Issue: Port conflicts

**Symptoms:**
```
Error: bind: address already in use
```

**Solution:**
```bash
# Check what's using the port
lsof -i :8080  # or whatever port you're using

# Kill the process
kill -9 <PID>

# Or change the port in docker-compose.yml
```

---

## Container Won't Start

### Issue: Container exits immediately

**Symptoms:**
```
docker-compose ps
NAME                STATUS              COMMAND
finance-yt-automation Exit (1)           "python3 main.py"
```

**Solution:**

1. Check container logs:
```bash
docker-compose logs finance-yt-automation
```

2. Common causes:
   - Missing `.env` file with API tokens
   - Invalid configuration in `config/config.yaml`
   - Permission issues on data directories

3. Fix with:
```bash
# Check if .env exists
ls -la .env

# Verify configuration
docker-compose config

# Check for permission issues
chmod -R 755 ./data ./logs ./output

# Rebuild if needed
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Issue: Container stuck in "Restarting"

**Symptoms:**
```
STATUS: Restarting (1) 5 seconds ago
```

**Solution:**

1. Check why it's restarting:
```bash
docker-compose logs --tail=50 finance-yt-automation
```

2. Common reasons:
   - Configuration errors
   - Missing dependencies
   - Insufficient resources

3. Fix:
```bash
# Check resource limits
docker stats finance-yt-automation

# Increase limits in docker-compose.yml
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 4G

# Restart with new limits
docker-compose up -d --force-recreate
```

---

## Permission Issues

### Issue: Permission denied on data directories

**Symptoms:**
```
PermissionError: [Errno 13] Permission denied: './data/videos'
```

**Solution:**

1. Fix directory permissions:
```bash
cd ~/finance-yt-automation
chmod -R 755 data logs output
chmod +x docker-setup.sh
```

2. Change ownership:
```bash
# Replace with your user ID
sudo chown -R $USER:$USER data logs output
```

3. Check file permissions:
```bash
ls -la data/
ls -la logs/
```

### Issue: Can't write to mounted volumes

**Symptoms:**
```
Error: unable to open file
```

**Solution:**

1. Verify volume mounts in docker-compose.yml:
```yaml
volumes:
  - ./data:/app/data
  - ./logs:/app/logs
  - ./output:/app/output
```

2. Ensure host directories exist:
```bash
mkdir -p data/{videos,scripts,audio,thumbnails,uploads}
mkdir -p logs
mkdir -p output
```

3. Check permissions:
```bash
ls -ld data logs output
```

---

## API Token Problems

### Issue: Hugging Face token not working

**Symptoms:**
```
Error: Invalid API token
```

**Solution:**

1. Verify token in `.env`:
```bash
cat .env | grep HUGGINGFACE
```

2. Test token directly:
```bash
docker-compose exec finance-yt-automation python3 -c "
from huggingface_hub import login
login(token='your_token_here')
print('Token validated!')
"
```

3. Regenerate token:
   - Go to https://huggingface.co/settings/tokens
   - Create new token with write access
   - Update `.env` file

### Issue: YouTube API credentials invalid

**Symptoms:**
```
Error: Invalid OAuth credentials
```

**Solution:**

1. Verify credentials in `.env`:
```bash
cat .env | grep YOUTUBE
```

2. Check OAuth flow:
```bash
# Generate new credentials at:
# https://console.cloud.google.com/apis/credentials
```

3. Refresh token if expired:
```bash
# Use OAuth flow to get new refresh token
# Update YOUTUBE_REFRESH_TOKEN in .env
```

---

## Performance Issues

### Issue: Container uses too much CPU

**Symptoms:**
```
docker stats
CONTAINER           CPU %   MEM USAGE / LIMIT
finance-yt-automation  200%   1.5GB / 2GB
```

**Solution:**

1. Check current usage:
```bash
docker stats finance-yt-automation
```

2. Adjust resource limits in docker-compose.yml:
```yaml
deploy:
  resources:
    limits:
      cpus: '4'      # Increase limit
      memory: 4G     # Increase memory
```

3. Optimize configuration:
   - Reduce `max_tokens` in config
   - Use smaller models
   - Reduce parallel operations

### Issue: Slow video creation

**Symptoms:**
- Videos taking too long to generate
- Container memory issues

**Solution:**

1. Increase memory limit:
```yaml
deploy:
  resources:
    limits:
      memory: 4G
```

2. Optimize Python code:
   - Reduce batch size
   - Use caching
   - Implement rate limiting

3. Monitor performance:
```bash
docker stats finance-yt-automation --no-stream
```

---

## Volume Mount Issues

### Issue: Volume not persisting

**Symptoms:**
- Data lost after container restart
- Empty directories after rebuild

**Solution:**

1. Check volume configuration:
```bash
docker-compose config | grep volumes
```

2. Verify volume names:
```bash
docker volume ls | grep finance
```

3. Check volume details:
```bash
docker volume inspect finance-yt-automation-data
```

4. Rebuild with correct volumes:
```bash
docker-compose down -v
docker-compose up -d
```

### Issue: Permission mismatch on volumes

**Symptoms:**
```
Permission denied when accessing mounted files
```

**Solution:**

1. Check UID/GID mapping:
```bash
docker-compose exec finance-yt-automation id
```

2. Fix permissions:
```bash
# Get container's UID
CONTAINER_UID=$(docker-compose exec finance-yt-automation id -u)

# Set host directory permissions
sudo chown -R $CONTAINER_UID:$CONTAINER_UID data logs output
```

---

## Network Issues

### Issue: Can't connect to external services

**Symptoms:**
```
ConnectionError: Failed to connect to API
```

**Solution:**

1. Check network status:
```bash
docker network ls
docker network inspect yt-automation-network
```

2. Test connectivity:
```bash
docker-compose exec finance-yt-automation ping -c 3 api.huggingface.co
```

3. Verify DNS resolution:
```bash
docker-compose exec finance-yt-automation nslookup huggingface.co
```

### Issue: Services can't communicate

**Symptoms:**
- Redis/Postgres services unreachable

**Solution:**

1. Check service status:
```bash
docker-compose ps
```

2. Verify network connectivity:
```bash
docker-compose exec finance-yt-automation ping redis
docker-compose exec finance-yt-automation ping postgres
```

3. Restart services:
```bash
docker-compose restart
```

---

## Log Issues

### Issue: Logs not showing

**Symptoms:**
- `docker-compose logs` returns nothing
- No output from container

**Solution:**

1. Check container status:
```bash
docker-compose ps
```

2. Verify logging configuration:
```bash
docker inspect finance-yt-automation | grep -A 10 Logging
```

3. Check log file directly:
```bash
tail -f logs/automation.log
```

4. Enable debug logging:
```bash
# In docker-compose.yml
environment:
  - LOG_LEVEL=DEBUG
```

### Issue: Logs are not rotating

**Symptoms:**
- Logs file keeps growing without rotation

**Solution:**

1. Check log configuration:
```bash
docker inspect finance-yt-automation | grep -A 10 "log_driver"
```

2. Verify log options:
```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

3. Restart with new config:
```bash
docker-compose down
docker-compose up -d
```

---

## Maintenance Tasks

### Clean up Docker resources

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Clean everything
docker system prune -a --volumes
```

### Check Docker disk usage

```bash
docker system df
```

### Monitor container performance

```bash
# Real-time stats
docker stats

# Top containers by CPU
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Top containers by memory
docker stats --no-stream --format "table {{.Name}}\t{{.MemPerc}}"
```

---

## Getting Help

If you encounter issues not covered here:

1. **Check logs first:**
```bash
docker-compose logs -f --tail=100
```

2. **Verify configuration:**
```bash
docker-compose config
```

3. **Check system status:**
```bash
docker-compose ps
docker stats
```

4. **Search for similar issues:**
   - GitHub issues
   - Docker forums
   - Stack Overflow

5. **Provide detailed information:**
   - Docker version: `docker --version`
   - Docker Compose version: `docker-compose --version`
   - Container logs
   - Configuration files
   - Error messages

---

## Quick Reference Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart services
docker-compose restart

# View logs
docker-compose logs -f

# Check status
docker-compose ps

# Rebuild container
docker-compose build --no-cache

# Enter container shell
docker-compose exec finance-yt-automation /bin/sh

# Execute single command
docker-compose run --rm finance-yt-automation python3 main.py

# Clean everything
docker-compose down -v
docker system prune -a --volumes
```
