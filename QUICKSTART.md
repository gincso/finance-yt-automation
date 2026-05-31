# Quick Start Guide

Get your Finance YouTube Automation running in 5 minutes!

## Step 1: Install Dependencies

```bash
cd ~/finance-yt-automation
pip install -r requirements.txt
```

## Step 2: Run Once to Test

```bash
python3 main.py
```

You should see output in your terminal showing:
- Selected topic
- Research completed
- Script written
- Video created

## Step 3: Check Results

```bash
ls -la data/videos/
ls -la data/scripts/
ls -la data/audio/
ls -la data/thumbnails/
```

## Step 4: Set Up Daily Automation (Optional)

```bash
crontab -e
```

Add this line (runs every day at 9:00 AM UTC):

```
0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && python3 main.py >> logs/cron.log 2>&1
```

## Step 5: Monitor Logs

```bash
tail -f logs/automation.log
```

## Next Steps

1. **Add API Keys**: Edit `config/config.yaml` and add your Hugging Face token
2. **Implement Real LLM Calls**: Replace mock implementations with actual API calls
3. **Add Video Processing**: Install FFmpeg for real video generation
4. **Configure YouTube**: Set up YouTube API for automatic uploads

## Troubleshooting

**No output from terminal commands?**
- Try using `python3` instead of `python`
- Check that pip installed successfully
- Verify all files were created in the project directory

**Import errors?**
- Make sure you're in the project directory: `cd ~/finance-yt-automation`
- Install dependencies: `pip install -r requirements.txt`

**Permissions errors?**
- Make scripts executable: `chmod +x scripts/*.sh`

## Need Help?

- Check `README.md` for detailed documentation
- Review `config/config.yaml` for configuration options
- Look at `logs/automation.log` for error messages

---

**You're ready to automate! 🚀**
