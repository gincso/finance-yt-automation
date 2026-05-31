# Quick Reference - Finance YouTube Automation

## Quick Start Commands

```bash
cd ~/finance-yt-automation

# Setup
./docker-setup.sh

# Run once
docker-compose run --rm finance-yt-automation python3 main.py

# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Check status
docker-compose ps

# Stop
docker-compose down
```

## Daily Automation

```bash
# Add to crontab
crontab -e

# Add this line:
0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && docker-compose run --rm finance-yt-automation python3 main.py
```

## Common Tasks

```bash
# Create one video
docker-compose run --rm finance-yt-automation python3 main.py

# Check output
ls -lh output/videos/

# View logs
tail -f logs/automation.log

# Monitor container
docker stats finance-yt-automation

# Enter container
docker-compose exec finance-yt-automation /bin/sh

# Rebuild
docker-compose build --no-cache
docker-compose up -d --force-recreate
```

## Configuration Files

```
finance-yt-automation/
├── .env                  # Environment variables (API tokens)
├── config/
│   └── config.yaml       # Main configuration
├── docker-compose.yml    # Docker orchestration
└── main.py               # Main entry point
```

## Environment Variables

```bash
# Required
HUGGINGFACE_API_TOKEN=hf_XXX...n

# Optional (for uploads)
YOUTUBE_CLIENT_ID=your_client_id.apps.googleusercontent.com
YOUTUBE_CLIENT_SECRET=your_c...n
YOUTUBE_REFRESH_TOKEN=your_refresh_token
```

## Output Locations

```
output/
├── videos/        # Generated videos
├── scripts/       # Generated scripts
├── audio/         # Audio files
├── thumbnails/    # Thumbnail images
└── last_run.json  # Last run status
```

## Monitoring

```bash
# Container health
docker inspect --format='{{.State.Health.Status}}' finance-yt-automation

# Resource usage
docker stats finance-yt-automation

# Disk usage
du -sh data/ logs/ output/

# Log files
tail -f logs/automation.log
grep ERROR logs/automation.log
```

## Troubleshooting

```bash
# Check logs
docker-compose logs finance-yt-automation

# Fix permissions
chmod -R 755 data logs output

# Rebuild container
docker-compose build --no-cache
docker-compose up -d

# View all logs
docker-compose logs -f --tail=100
```

## Topics Covered

- Budgeting (saving, budget creation, mistakes)
- Investing (index funds, starting small, compound interest)
- Crypto (Bitcoin, buying safely, DeFi vs CeFi)
- Retirement (401k, IRA, passive income)
- Real Estate (renting vs buying, REITs)
- Debt Management (credit cards, loans, consolidation)
- Passive Income (dividends, side hustles, investments)
- Credit Score (building, improving, monitoring)
- Emergency Fund (amount, location, growth)
- Tax Planning (deductions, credits, strategies)
- And 40+ more topics...

## Models Available

**Free Tier:**
- `HuggingFaceH4/zephyr-7b-beta`

**Paid Tier:**
- `mistralai/Mistral-7B-Instruct-v0.2`
- `meta-llama/Llama-2-7b-chat-hf`
- `gpt2`

## Resource Limits

- CPU: 2 cores max
- Memory: 2GB max
- Video duration: 3-5 minutes
- Video quality: HD (1080p)

## Support

- **Guide**: `USAGE_GUIDE.md`
- **Docker**: `DOCKER_DEPLOYMENT.md`
- **Troubleshooting**: `DOCKER_TROUBLESHOOTING.md`
- **GitHub**: https://github.com/gincso/finance-yt-automation

---

**Need Help?** Check the logs and documentation.
