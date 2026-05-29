# Automated Finance YouTube Channel

A zero-capital, multi-agent system for creating automated finance content for YouTube with minimal human interaction.

## 🎯 Features

- ✅ **Zero Startup Capital** - Uses free tools and APIs
- ✅ **Multi-Agent Architecture** - Specialized agents for different tasks
- ✅ **Free LLM Models** - Open-source models via Hugging Face
- ✅ **Open-Source Video Generation** - No expensive video AI required
- ✅ **Minimal Human Interaction** - Fully automated workflow
- ✅ **Content Variety** - 50+ finance topics covered
- ✅ **Scalable** - Can produce multiple videos per day

## 🚀 Quick Start

### Local Setup

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/finance-yt-automation.git
cd finance-yt-automation

# Run setup script
./setup.sh

# Create your first video
python3 scripts/orchestrator.py --single

# Create multiple videos
python3 scripts/orchestrator.py --batch 5

# Continuous mode (auto-schedule)
python3 scripts/orchestrator.py --continuous
```

### GitHub Actions Automation

This repository includes GitHub Actions workflows for automated content creation:

- **Daily Video Creation** - Runs every day at 9:00 AM UTC
- **Batch Video Creation** - Create multiple videos manually
- **YouTube Upload** - Upload videos to YouTube automatically
- **Content Monitoring** - Generate production reports

## 📁 Project Structure

```
finance-yt-automation/
├── .github/
│   └── workflows/          # GitHub Actions workflows
│       ├── daily-video-creation.yml
│       ├── batch-video-creation.yml
│       ├── youtube-upload.yml
│       └── monitoring.yml
├── scripts/
│   ├── generate_content.py    # Content generation agent
│   ├── create_video.py        # Video creation agent
│   ├── orchestrator.py        # Main orchestration
│   ├── upload_youtube.py      # YouTube upload script
│   └── create_upload_script.py # Upload script generator
├── content/
│   └── topics.py             # 50+ finance topics
├── output/                    # Generated content
│   └── videos/               # Video scripts and metadata
├── logs/                      # Execution logs
├── config/
│   └── config.yaml           # Configuration file
├── requirements.txt          # Python dependencies
├── setup.sh                  # Automated setup script
├── README.md                 # This file
├── QUICKSTART.md             # Quick start guide
├── COMPLETE_SETUP_GUIDE.md   # Complete setup guide
└── PROJECT_SUMMARY.md        # Project overview
```

## 🤖 Multi-Agent System

### 1. Content Researcher Agent
- Selects trending finance topics
- Identifies relevant keywords
- Categorizes content by difficulty level

### 2. Content Writer Agent
- Generates engaging video scripts
- Uses free LLM (Hugging Face)
- Creates optimized descriptions

### 3. Video Creator Agent
- Splits scripts into scenes
- Generates visual descriptions
- Creates video structure

### 4. Uploader Agent
- Prepares YouTube metadata
- Optimizes for SEO
- Manages upload scheduling

## 💰 Cost Analysis

### Current Implementation (Free)

| Component | Cost | Notes |
|-----------|------|-------|
| LLM API | $0 | Free tier available |
| YouTube | $0 | Free platform |
| Storage | $0 | Free (local) |
| **Total** | **$0** | |

### Optional Enhancements (Low Cost)

| Service | Cost | Notes |
|---------|------|-------|
| HeyGen | $0-$10 | Free tier available |
| RunwayML | $0-$25 | Limited free credits |
| Pexels API | $0 | Free tier |
| **Total** | **$0-$35** | |

## 📊 Content Topics

The system includes 50+ finance topics covering:

- **Personal Finance**: Budgeting, saving, emergency funds
- **Investment Strategies**: Stocks, index funds, compound interest
- **Cryptocurrency**: Bitcoin, Ethereum, security
- **Retirement Planning**: 401k, IRA, tax advantages
- **Real Estate Investing**: REITs, rental properties, ROI
- **Debt Management**: Snowball method, credit scores
- **Passive Income**: Dividends, digital products

## 🎬 Usage

### Single Video Workflow

```bash
python3 scripts/orchestrator.py --single
```

### Batch Processing

```bash
python3 scripts/orchestrator.py --batch 5
```

### Continuous Mode

```bash
python3 scripts/orchestrator.py --continuous
```

### Manual Upload

```bash
# Set YouTube API key
export YOUTUBE_API_KEY="***"

# Create upload script
python3 scripts/create_upload_script.py

# Upload
python3 scripts/upload_youtube.py
```

## ⚙️ Configuration

Edit `config/config.yaml` to customize:

```yaml
# Content settings
content_strategy:
  channel_name: "Wealth Wisdom"
  target_audience: "Beginners to intermediate investors"

# AI model settings
ai_models:
  llm:
    model: "meta-llama/Llama-3.2-3B-Instruct"
    temperature: 0.7

# Video settings
video_creation:
  duration: 30
  quality: "high"

# Automation settings
automation:
  schedule:
    videos_per_day: 2
    upload_time: "09:00"
```

## 🔧 GitHub Actions

### Enable Workflows

1. Go to **Settings** → **Actions** → **General**
2. Under **Workflow permissions**, select **Read and write permissions**
3. Click **Save**

### Configure Secrets

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Add the following secrets:

| Secret Name | Description |
|-------------|-------------|
| `HUGGINGFACE_TOKEN` | Your Hugging Face API token |
| `YOUTUBE_API_KEY` | Your YouTube Data API key |

### Trigger Workflows

- **Daily Video Creation**: Runs automatically at 9:00 AM UTC
- **Batch Video Creation**: Manual trigger with batch size
- **YouTube Upload**: Runs at 10:00 AM UTC (after video creation)
- **Content Monitoring**: Runs at 11:00 AM UTC

## 📈 Performance

### Current Performance

- Content generation: < 30 seconds per video
- Video structure: < 10 seconds
- Total workflow: < 1 minute per video
- Monthly cost: $0 (free tier)

### Scalability

- Batch processing: Multiple videos concurrently
- Continuous mode: Auto-scheduled uploads
- Memory efficient: Minimal resource usage

## 🛠 Troubleshooting

### Common Issues

1. **LLM API Errors**
   - Check Hugging Face token
   - Verify API quota
   - Use fallback script generation

2. **Video Creation Issues**
   - Install FFmpeg: `pip install ffmpeg-python`
   - Check Python dependencies
   - Verify file permissions

3. **YouTube API Issues**
   - Verify API key
   - Check API quota
   - Enable YouTube Data API v3

### Check Logs

```bash
# View execution logs
tail -f logs/automation_$(date +%Y%m%d).log

# Check GitHub Actions logs
# Go to Actions tab in repository
```

## 📚 Documentation

- **README.md** - Complete documentation (this file)
- **QUICKSTART.md** - Quick start guide
- **COMPLETE_SETUP_GUIDE.md** - Complete setup instructions
- **PROJECT_SUMMARY.md** - Project overview and architecture

## 🎓 Learning Resources

### Finance Content

- Investopedia - Investment education
- Khan Academy - Financial literacy
- Personal Finance Subreddit - Community insights

### Video Creation

- FFmpeg Documentation - Video processing
- Pexels API - Stock footage
- HeyGen - Text-to-video (free tier)

### Automation

- GitHub Actions - CI/CD
- Cron Jobs - Scheduling
- Python Libraries - Automation tools

## ⚠️ Legal & Compliance

### Important Notes

1. **Content Verification**: Always review generated content
2. **YouTube Policies**: Follow all platform guidelines
3. **Financial Advice**: Include proper disclaimers
4. **Accuracy**: Verify financial information
5. **Copyright**: Use licensed content or create original

### Best Practices

- Review all content before publishing
- Include financial disclaimers
- Provide educational value
- Cite sources when appropriate
- Stay updated with regulations

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - Feel free to use and modify for your own projects.

## 🙏 Credits

- Open-source models and APIs
- Free tools and resources
- Community contributions

## 📞 Support

For issues or questions:

1. Check logs in `logs/` directory
2. Review error messages
3. Verify configuration
4. Check API quotas
5. See documentation files

## 🎯 Success Metrics

Track these metrics:

- **Views per video**
- **Engagement rate**
- **Subscriber growth**
- **Video completion rate**
- **Click-through rate**

## 🚀 Getting Started

1. **Review the README.md** for complete documentation
2. **Read QUICKSTART.md** for quick setup instructions
3. **Run setup.sh** to initialize the project
4. **Create your first video** with `--single` flag
5. **Set up GitHub Actions** for automation
6. **Upload to YouTube** and start growing!

---

**Note**: This is a demonstration system. For production use, review and validate all content before publishing.

## 📊 Current Status

- ✅ Multi-agent system active
- ✅ GitHub Actions workflows configured
- ✅ Daily automation scheduled
- ✅ Zero startup capital
- ✅ Ready for production

**Total Cost: $0**
**Time to First Video: < 5 minutes**
**Monthly Output: Unlimited (with free tier limits)**
