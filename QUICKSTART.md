
# Quick Start Guide

## 1. Setup (One-time)

Run the setup script:
```bash
cd ~/finance-yt-automation
./setup.sh
```

## 2. Configure API Tokens

Get free Hugging Face token from: https://huggingface.co/settings/tokens
Get free YouTube API key from: https://console.cloud.google.com/apis/credentials

## 3. Create Your First Video

```bash
cd ~/finance-yt-automation
python3 scripts/orchestrator.py --single
```

## 4. Create Multiple Videos

```bash
python3 scripts/orchestrator.py --batch 5
```

## 5. Continuous Mode

```bash
python3 scripts/orchestrator.py --continuous
```

## 6. Check Results

Look in:
- Scripts: ~/finance-yt-automation/content/scripts/
- Videos: ~/finance-yt-automation/output/videos/
- Logs: ~/finance-yt-automation/logs/

## 7. Upload to YouTube

Use the generated metadata files to upload manually, or integrate with YouTube API.

## Cost: $0

All tools used have free tiers available.
