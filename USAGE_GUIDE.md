# Finance YouTube Automation - Complete Usage Guide

This guide provides detailed instructions on how to use the Finance YouTube Automation system for creating automated faceless finance videos.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quick Start](#quick-start)
4. [Running Manual](#running-manual)
5. [Docker Usage](#docker-usage)
6. [Cron Job Setup](#cron-job-setup)
7. [Configuration](#configuration)
8. [Workflow Explanation](#workflow-explanation)
9. [Monitoring](#monitoring)
10. [Troubleshooting](#troubleshooting)

---

## Overview

The Finance YouTube Automation system is a multi-agent system that:

1. **Researches** finance topics (50+ topics covering budgeting, investing, crypto, retirement, etc.)
2. **Writes** video scripts using LLMs
3. **Creates** videos with voiceover and visuals
4. **Uploads** to YouTube (optional)

**Key Features:**
- Zero startup capital (uses free LLM tiers)
- Daily automation via cron
- Complete documentation
- Docker support
- Production-ready

---

## Prerequisites

### For Local Usage

- Python 3.8+
- pip package manager
- ffmpeg (for video processing)
- Hugging Face API token (free tier)
- YouTube API credentials (optional, for uploads)

### For Docker Usage

- Docker (20.10+)
- Docker Compose (2.0+)

---

## Quick Start

### Option 1: Docker (Recommended)

```bash
# 1. Clone and setup
cd ~/finance-yt-automation
./docker-setup.sh

# 2. Configure API tokens (if not already done)
nano .env

# 3. Run automation
docker-compose run --rm finance-yt-automation python3 main.py

# 4. Check results
ls -la output/videos/
```

### Option 2: Local Python

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Configure environment
cp config/config.yaml.example config/config.yaml
nano config/config.yaml

# 3. Run automation
python3 main.py

# 4. Check results
ls -la output/videos/
```

---

## Running Manual

### Single Video Creation

Run the automation once to create a single video:

```bash
# Docker
docker-compose run --rm finance-yt-automation python3 main.py

# Local
python3 main.py
```

### Check Configuration

Before running, verify your configuration:

```bash
# Docker
docker-compose config

# Local
cat config/config.yaml
```

### View Logs

```bash
# Docker
docker-compose logs -f

# Local
tail -f logs/automation.log
```

### Check Output

```bash
# View created videos
ls -lh output/videos/

# View generated scripts
cat output/scripts/last_script.txt

# Check last run status
cat output/videos/last_run.json
```

---

## Docker Usage

### Start Services

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps
```

### Run Once

```bash
# Run automation in container
docker-compose run --rm finance-yt-automation python3 main.py

# Run with custom config
docker-compose run --rm finance-yt-automation python3 main.py --config config/custom.yaml
```

### View Logs

```bash
# Follow all logs
docker-compose logs -f

# Follow main service only
docker-compose logs -f finance-yt-automation

# View last 100 lines
docker-compose logs --tail=100 finance-yt-automation

# Search for errors
docker-compose logs -f | grep ERROR
```

### Stop Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (data will be lost)
docker-compose down -v

# Stop and remove volumes + images
docker-compose down -v --rmi all
```

### Restart Services

```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart finance-yt-automation
```

### Enter Container Shell

```bash
# Enter main container
docker-compose exec finance-yt-automation /bin/sh

# Run a single command
docker-compose exec finance-yt-automation python3 --version
```

### Rebuild Container

```bash
# Rebuild without cache
docker-compose build --no-cache

# Rebuild and restart
docker-compose up -d --force-recreate
```

---

## Cron Job Setup

### Schedule Daily Automation

Set up a cron job to run the automation daily at 9:00 AM UTC:

```bash
# Edit crontab
crontab -e

# Add this line:
0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && docker-compose run --rm finance-yt-automation python3 main.py >> logs/cron.log 2>&1
```

### Alternative: Using Docker Compose Cron

Create a cron job that uses docker-compose:

```bash
# Add to crontab
0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && docker-compose run --rm finance-yt-automation python3 main.py
```

### Test Cron Job

```bash
# Run manually to test
docker-compose run --rm finance-yt-automation python3 main.py

# Check logs
docker-compose logs --tail=50
```

### View Cron Jobs

```bash
# List all cron jobs
crontab -l

# View cron logs
tail -f /var/log/syslog | grep CRON
```

### Remove Cron Job

```bash
# Edit crontab
crontab -e

# Delete the line you added
```

---

## Configuration

### Environment Variables

Edit `.env` file:

```bash
nano .env
```

Required variables:

```bash
# Hugging Face API (required)
HUGGINGFACE_API_TOKEN=hf_XXXXXXXXXXXXXXXXXXXX

# YouTube API (optional, for uploads)
YOUTUBE_CLIENT_ID=your_client_id.apps.googleusercontent.com
YOUTUBE_CLIENT_SECRET=your_client_secret
YOUTUBE_REFRESH_TOKEN=your_refresh_token
```

### Configuration File

Edit `config/config.yaml`:

```bash
nano config/config.yaml
```

Key settings:

```yaml
# Agents configuration
agents:
  researcher:
    model: "HuggingFaceH4/zephyr-7b-beta"  # Free model
    max_tokens: 500
    temperature: 0.7

  writer:
    model: "HuggingFaceH4/zephyr-7b-beta"
    max_tokens: 1000
    temperature: 0.8

  video_creator:
    model: "HuggingFaceH4/zephyr-7b-beta"
    max_tokens: 800
    temperature: 0.7

# Output paths
output:
  videos_dir: "./output/videos"
  scripts_dir: "./output/scripts"
  audio_dir: "./output/audio"
  thumbnails_dir: "./output/thumbnails"

# Topics to cover
topics:
  budgeting:
    - "10 simple ways to save $500 this month"
    - "How to create a monthly budget"
    - "5 budgeting mistakes to avoid"

  investing:
    - "Index funds vs individual stocks: which is better?"
    - "How to start investing with $100"
    - "Compound interest explained"

  crypto:
    - "Bitcoin halving explained"
    - "How to safely buy crypto"
    - "DeFi vs CeFi: what's the difference?"

  retirement:
    - "How much do I need to retire at 40?"
    - "401k vs IRA: which is better?"
    - "Passive income ideas for retirement"

# YouTube settings (optional)
youtube:
  enabled: false
  channel_id: ""
```

### Select Different Models

To use different LLM models:

```yaml
# Free models (recommended)
researcher:
  model: "HuggingFaceH4/zephyr-7b-beta"

writer:
  model: "HuggingFaceH4/zephyr-7b-beta"

video_creator:
  model: "HuggingFaceH4/zephyr-7b-beta"

# Paid models (higher quality)
researcher:
  model: "mistralai/Mistral-7B-Instruct-v0.2"

writer:
  model: "meta-llama/Llama-2-7b-chat-hf"

video_creator:
  model: "mistralai/Mistral-7B-Instruct-v0.2"
```

---

## Workflow Explanation

### Step 1: Topic Selection

The system randomly selects a finance topic from the `config/config.yaml` topics list:

```yaml
topics:
  budgeting:
    - "10 simple ways to save $500 this month"
    - "How to create a monthly budget"
```

### Step 2: Content Research

The Researcher agent gathers information about the selected topic using the LLM:

```python
research_data = researcher.research(topic)
```

### Step 3: Script Writing

The Writer agent creates a video script based on research:

```python
script = writer.write_script(research_data, topic)
```

### Step 4: Video Creation

The Video Creator agent generates the video:

```python
video_path = video_creator.create_video(script, topic)
```

This includes:
- Voiceover generation
- Visual elements
- Background music
- Subtitles

### Step 5: Upload (Optional)

The Uploader agent uploads to YouTube:

```python
upload_result = uploader.upload(video_path)
```

### Step 6: Logging

All activities are logged to `logs/automation.log`:

```
2024-01-15 09:00:00 - INFO - Starting Finance YouTube Automation
2024-01-15 09:00:01 - INFO - Selected topic: budgeting - 10 simple ways to save $500 this month
2024-01-15 09:00:05 - INFO - Researching topic...
2024-01-15 09:00:30 - INFO - Writing video script...
2024-01-15 09:02:00 - INFO - Creating video...
2024-01-15 09:10:00 - INFO - Video created: output/videos/10_simple_ways_to_save_500_this_month.mp4
2024-01-15 09:10:01 - INFO - Automation Complete!
```

---

## Monitoring

### Check Container Health

```bash
# Check if container is healthy
docker inspect --format='{{.State.Health.Status}}' finance-yt-automation

# View health check logs
docker inspect --format='{{range .State.Health.Log}}{{.Output}}{{end}}' finance-yt-automation
```

### Monitor Resources

```bash
# Real-time stats
docker stats finance-yt-automation

# Top containers by CPU
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Top containers by memory
docker stats --no-stream --format "table {{.Name}}\t{{.MemPerc}}"
```

### Check Disk Usage

```bash
# Check data directory size
du -sh data/

# Check log file size
du -sh logs/

# Check output size
du -sh output/
```

### Monitor Logs

```bash
# Follow logs in real-time
tail -f logs/automation.log

# View recent logs
tail -100 logs/automation.log

# Search for errors
grep ERROR logs/automation.log

# Search for specific topics
grep "saving" logs/automation.log
```

### Check Last Run Status

```bash
# View last run JSON
cat output/videos/last_run.json

# Check video count
ls -1 output/videos/ | wc -l
```

---

## Troubleshooting

### Common Issues

#### Issue: "Permission denied" error

```bash
# Fix permissions
chmod -R 755 data logs output
```

#### Issue: Container won't start

```bash
# Check logs
docker-compose logs finance-yt-automation

# Rebuild container
docker-compose build --no-cache
docker-compose up -d
```

#### Issue: API token not working

```bash
# Verify token in .env
cat .env | grep HUGGINGFACE

# Test token
docker-compose exec finance-yt-automation python3 -c "
from huggingface_hub import login
login(token='your_token_here')
print('Token validated!')
"
```

#### Issue: Video creation fails

```bash
# Check ffmpeg is installed
docker-compose exec finance-yt-automation ffmpeg -version

# Check disk space
df -h

# Check available memory
free -h
```

### Debug Mode

Enable debug logging:

```bash
# In docker-compose.yml
environment:
  - LOG_LEVEL=DEBUG

# In config/config.yaml
logging:
  level: DEBUG
```

### Reset Everything

```bash
# Stop and remove all
docker-compose down -v
docker system prune -a --volumes

# Rebuild from scratch
./docker-setup.sh
```

---

## Tips and Best Practices

### 1. Start with Test Runs

```bash
# Run once to test
docker-compose run --rm finance-yt-automation python3 main.py

# Check output
ls -lh output/videos/
```

### 2. Monitor First Few Runs

```bash
# Watch logs while running
docker-compose logs -f finance-yt-automation

# Check after completion
docker-compose logs --tail=50 finance-yt-automation
```

### 3. Adjust Resource Limits

If experiencing performance issues:

```yaml
# In docker-compose.yml
deploy:
  resources:
    limits:
      cpus: '4'      # Increase CPU
      memory: 4G     # Increase memory
```

### 4. Use Appropriate Models

- Free tier: `HuggingFaceH4/zephyr-7b-beta`
- Paid tier: `mistralai/Mistral-7B-Instruct-v0.2`

### 5. Regular Backups

```bash
# Backup data
tar czf backup-$(date +%Y%m%d).tar.gz data logs output

# Restore from backup
tar xzf backup-20240115.tar.gz
```

### 6. Clean Up Old Files

```bash
# Remove videos older than 30 days
find output/videos/ -type f -mtime +30 -delete

# Remove old logs
find logs/ -name "*.log" -mtime +7 -delete
```

---

## Examples

### Example 1: Create One Video

```bash
cd ~/finance-yt-automation
docker-compose run --rm finance-yt-automation python3 main.py
```

### Example 2: Run Daily at 9 AM UTC

```bash
# Add to crontab
crontab -e

# Add this line:
0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && docker-compose run --rm finance-yt-automation python3 main.py
```

### Example 3: Monitor and Log

```bash
# Run in background
docker-compose up -d

# Monitor logs
docker-compose logs -f

# Save logs to file
docker-compose logs -f > automation_$(date +%Y%m%d_%H%M%S).log
```

### Example 4: Use Custom Configuration

```bash
# Create custom config
cp config/config.yaml config/config.local.yaml

# Edit custom config
nano config/config.local.yaml

# Run with custom config
docker-compose run --rm finance-yt-automation python3 main.py --config config/config.local.yaml
```

### Example 5: Check All Outputs

```bash
# List all videos
ls -lh output/videos/

# Count videos
ls -1 output/videos/ | wc -l

# Check last script
cat output/scripts/last_script.txt

# View last run status
cat output/videos/last_run.json | jq .
```

---

## Next Steps

1. **Configure API tokens** - Get your Hugging Face token
2. **Run test** - Create your first video
3. **Monitor** - Watch logs and check output
4. **Set up cron** - Automate daily creation
5. **Scale** - Add more topics and models
6. **Optimize** - Adjust resources and settings

---

## Resources

- **Configuration Guide**: `config/config.yaml`
- **Docker Guide**: `DOCKER_DEPLOYMENT.md`
- **Troubleshooting**: `DOCKER_TROUBLESHOOTING.md`
- **GitHub Repository**: https://github.com/gincso/finance-yt-automation
- **Hugging Face**: https://huggingface.co/

---

## Support

For issues or questions:

1. Check logs: `docker-compose logs -f`
2. Review troubleshooting guide
3. Check GitHub issues
4. Verify configuration files

---

**Happy automating!** 🎬
