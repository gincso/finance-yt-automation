# Finance YouTube Automation - Getting Started

## 🚀 Quick Start (5 Minutes)

### Step 1: Clone and Setup

```bash
cd ~/finance-yt-automation
./docker-setup.sh
```

This will:
- Check Docker installation
- Create .env from template
- Set up directories
- Build Docker images
- Start services
- Run test automation

### Step 2: Configure API Tokens

```bash
nano .env
```

Add your Hugging Face API token (free tier):

```bash
HUGGINGFACE_API_TOKEN=hf_XXX...n
```

Get a free token at: https://huggingface.co/settings/tokens

### Step 3: Run Your First Video

```bash
docker-compose run --rm finance-yt-automation python3 main.py
```

### Step 4: Check Your Video

```bash
ls -lh output/videos/
```

Your first finance video is ready!

---

## 📖 How to Use

### Option 1: Run One Video

```bash
cd ~/finance-yt-automation
docker-compose run --rm finance-yt-automation python3 main.py
```

### Option 2: Run Daily (Automated)

```bash
# Add to crontab
crontab -e

# Add this line:
0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && docker-compose run --rm finance-yt-automation python3 main.py
```

This will create a new video every day at 9:00 AM UTC.

### Option 3: Monitor and Check

```bash
# View logs
docker-compose logs -f

# Check status
docker-compose ps

# Check videos
ls -lh output/videos/

# Check last run
cat output/videos/last_run.json
```

---

## 📚 Documentation Guide

### Quick Reference
**QUICK_REFERENCE.md** - Fast command lookup

### Complete Usage
**USAGE_GUIDE.md** - Step-by-step instructions

### Visual Workflow
**WORKFLOW.md** - System architecture and data flow

### Docker Setup
**DOCKER_DEPLOYMENT.md** - Docker deployment guide

### Troubleshooting
**DOCKER_TROUBLESHOOTING.md** - Common issues and solutions

---

## 🔧 Configuration

### Environment Variables (.env)

Required:
```bash
HUGGINGFACE_API_TOKEN=hf_XXX...n  # Get free token
```

Optional (for uploads):
```bash
YOUTUBE_CLIENT_ID=your_client_id.apps.googleusercontent.com
YOUTUBE_CLIENT_SECRET=your_c...n
YOUTUBE_REFRESH_TOKEN=your_r...n
```

### Configuration (config.yaml)

Edit topics, models, and settings:

```yaml
agents:
  researcher:
    model: "HuggingFaceH4/zephyr-7b-beta"  # Free model
    max_tokens: 500

topics:
  budgeting:
    - "10 simple ways to save $500 this month"
    - "How to create a monthly budget"
```

---

## 📊 What Gets Created

### Videos
- Location: `output/videos/`
- Format: MP4
- Duration: 3-5 minutes
- Quality: HD (1080p)

### Scripts
- Location: `output/scripts/`
- Format: TXT
- Content: Video script with voiceover

### Thumbnails
- Location: `output/thumbnails/`
- Format: PNG
- Content: Auto-generated thumbnail

### Logs
- Location: `logs/automation.log`
- Content: Complete activity log

---

## 🎯 Topics Covered

The system creates videos on 50+ finance topics:

- **Budgeting**: Saving money, budget creation, avoiding mistakes
- **Investing**: Index funds, starting small, compound interest
- **Crypto**: Bitcoin, buying safely, DeFi vs CeFi
- **Retirement**: 401k, IRA, passive income
- **Real Estate**: Renting vs buying, REITs
- **Debt Management**: Credit cards, loans, consolidation
- **Credit Score**: Building, improving, monitoring
- **Emergency Fund**: Amount, location, growth
- **Tax Planning**: Deductions, credits, strategies
- **And 40+ more topics...**

---

## 📈 Monitoring

### Check Container Health

```bash
docker inspect --format='{{.State.Health.Status}}' finance-yt-automation
```

### Monitor Resources

```bash
docker stats finance-yt-automation
```

### Check Logs

```bash
tail -f logs/automation.log
```

### Check Disk Usage

```bash
du -sh data/ logs/ output/
```

---

## 🐛 Troubleshooting

### Container won't start

```bash
docker-compose logs finance-yt-automation
docker-compose build --no-cache
docker-compose up -d
```

### Permission issues

```bash
chmod -R 755 data logs output
```

### API token not working

```bash
cat .env | grep HUGGINGFACE
```

See **DOCKER_TROUBLESHOOTING.md** for detailed troubleshooting.

---

## 🔄 Common Commands

```bash
# Run once
docker-compose run --rm finance-yt-automation python3 main.py

# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Check status
docker-compose ps

# Restart
docker-compose restart

# Rebuild
docker-compose build --no-cache
docker-compose up -d
```

---

## 📞 Support

### Need Help?

1. Check logs: `docker-compose logs -f`
2. Review troubleshooting: `DOCKER_TROUBLESHOOTING.md`
3. Check usage guide: `USAGE_GUIDE.md`
4. View workflow: `WORKFLOW.md`

### Resources

- **GitHub**: https://github.com/gincso/finance-yt-automation
- **Hugging Face**: https://huggingface.co/
- **Docker**: https://docs.docker.com/

---

## ✅ Checklist

Before starting:

- [ ] Docker installed (20.10+)
- [ ] Docker Compose installed (2.0+)
- [ ] Hugging Face API token obtained
- [ ] .env file configured with token
- [ ] Directory permissions set (755)

After running:

- [ ] Video created in output/videos/
- [ ] Log file updated in logs/automation.log
- [ ] Container health is "healthy"
- [ ] No ERROR messages in logs

---

## 🎬 Example Output

```
==========================================
Starting Finance YouTube Automation
==========================================

[STEP 1] Researching topic...
Selected topic: budgeting - 10 simple ways to save $500 this month
Research complete

[STEP 2] Writing video script...
Script written successfully

[STEP 3] Creating video...
Video created: output/videos/10_simple_ways_to_save_500_this_month.mp4

==========================================
Automation Complete!
==========================================
```

---

## 🚀 Next Steps

1. **Run test** - Create your first video
2. **Monitor** - Watch logs and check output
3. **Configure** - Adjust topics and models
4. **Automate** - Set up cron job for daily runs
5. **Scale** - Add more topics and videos

---

## 💡 Tips

- Start with the free model: `HuggingFaceH4/zephyr-7b-beta`
- Monitor resource usage: `docker stats`
- Check logs regularly: `tail -f logs/automation.log`
- Backup your data: `tar czf backup.tar.gz data logs output`
- Clean up old files: `find output/videos/ -mtime +30 -delete`

---

## 📖 Documentation Files

```
finance-yt-automation/
├── README.md               # This file
├── QUICK_REFERENCE.md      # Quick command reference
├── USAGE_GUIDE.md          # Complete usage guide
├── WORKFLOW.md             # Visual workflow
├── DOCKER_DEPLOYMENT.md    # Docker deployment
├── DOCKER_TROUBLESHOOTING.md # Troubleshooting
├── docker-compose.yml      # Docker configuration
├── .env.example            # Environment template
└── main.py                 # Main entry point
```

---

**Ready to start?** Run `./docker-setup.sh` or `docker-compose run --rm finance-yt-automation python3 main.py`

**Need help?** Check `DOCKER_TROUBLESHOOTING.md` or `USAGE_GUIDE.md`

**Want to automate?** Add cron job: `0 9 * * * cd ~/finance-yt-automation && docker-compose run --rm finance-yt-automation python3 main.py`

🎬 **Happy automating!**
