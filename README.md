# Automated Faceless Finance YouTube Channel

A zero-capital, multi-agent system for creating automated finance content for YouTube with minimal human intervention.

## Features

✅ **Zero Startup Capital** - Uses free tools and APIs
✅ **Multi-Agent Architecture** - Specialized agents for different tasks
✅ **Free LLM Models** - Open-source models via Hugging Face
✅ **Open-Source Video Generation** - No expensive video AI required
✅ **Minimal Human Interaction** - Fully automated workflow
✅ **Content Variety** - 50+ finance topics covered
✅ **Scalable** - Can produce multiple videos per day

## Architecture

### Multi-Agent System

1. **Content Researcher Agent**
   - Selects trending finance topics
   - Identifies relevant keywords
   - Categorizes content by difficulty level

2. **Content Writer Agent**
   - Generates engaging video scripts
   - Creates optimized descriptions
   - Formats content for YouTube

3. **Video Creator Agent**
   - Splits scripts into scenes
   - Generates visual descriptions
   - Creates video structure

4. **Uploader Agent**
   - Prepares metadata for YouTube
   - Optimizes for SEO
   - Schedules uploads

## Installation

### Prerequisites

- Python 3.8+
- Termux (or any Unix-like system)
- Git

### Step 1: Clone or Create Project

```bash
# Create project directory
mkdir -p ~/finance-yt-automation
cd ~/finance-yt-automation

# Create directory structure
mkdir -p scripts content/templates content/scripts models output/videos logs config
```

### Step 2: Install Dependencies

```bash
# Install Python packages
pip install -r requirements.txt
```

### Step 3: Configure Hugging Face API

1. Get free API token from https://huggingface.co/settings/tokens
2. Set environment variable:
```bash
export HUGGINGFACE_TOKEN="your_token_here"
```

### Step 4: Configure YouTube API (Optional)

1. Enable YouTube Data API v3 at https://console.cloud.google.com
2. Create credentials
3. Set environment variable:
```bash
export YOUTUBE_API_KEY="your_api_key_here"
```

## Usage

### Single Video Workflow

```bash
python scripts/orchestrator.py --single
```

### Batch Processing (Create Multiple Videos)

```bash
python scripts/orchestrator.py --batch 5
```

### Continuous Mode (Auto-schedule)

```bash
python scripts/orchestrator.py --continuous
```

## Configuration

Edit `config/config.yaml` to customize:

- Content topics and categories
- Video generation settings
- Upload schedules
- AI model parameters
- YouTube optimization settings

## Content Topics

The system includes 50+ finance topics covering:

- Personal Finance (budgeting, saving, emergency funds)
- Investment Strategies (stocks, index funds, compound interest)
- Cryptocurrency (Bitcoin, Ethereum, security)
- Retirement Planning (401k, IRA, tax advantages)
- Real Estate Investing (REITs, rental properties)
- Debt Management (snowball method, credit scores)
- Passive Income (dividends, digital products)

## Video Generation

### Current Implementation

The system creates:
- Scene-based video structure
- Text overlays
- Visual descriptions
- Timeline management

### Production Implementation

For professional videos, integrate:

1. **Open-Source Options:**
   - Stable Video Diffusion (Hugging Face)
   - Video generation via FFmpeg
   - Stock footage from Pexels/Pixabay (free)

2. **Free Tier Services:**
   - HeyGen (text-to-video)
   - RunwayML (limited free credits)
   - Pika Labs (free tier available)

3. **Custom Implementation:**
   - Python + FFmpeg
   - Motion graphics
   - Animated charts

## Cost Analysis

### Monthly Costs (Estimated)

| Service | Cost | Notes |
|---------|------|-------|
| Hugging Face API | $0 | Free tier available |
| YouTube | $0 | Free to use |
| Storage | $0 | Free tier |
| **Total** | **$0** | Zero startup capital |

### Potential Costs (Production)

| Service | Cost | Notes |
|---------|------|-------|
| HeyGen | $0-$10 | Free tier available |
| RunwayML | $0-$25 | Limited free credits |
| Pexels API | $0 | Free tier |
| **Total** | **$0-$35** | Optional enhancements |

## Workflow

1. **Research Agent** selects topic
2. **Writer Agent** generates script
3. **Video Agent** creates structure
4. **Uploader Agent** prepares metadata
5. **Human Review** (optional) - Review and approve
6. **Upload** to YouTube (manual or automated)

## Customization

### Add New Topics

Edit `content/topics.py` and add new topics to the `finance_topics` or `trending_topics` lists.

### Modify Content Style

Update the system prompt in `config/config.yaml` to change writing style, tone, and complexity.

### Adjust Video Settings

Modify `config/config.yaml` under `video_creation` for:
- Duration
- Visual style
- Music and voiceover
- Subtitles

## Troubleshooting

### LLM API Errors

- Check Hugging Face token
- Verify API quota
- Use fallback script generation

### Video Creation Issues

- Install FFmpeg: `pkg install ffmpeg`
- Check Python dependencies
- Verify file permissions

### YouTube API Issues

- Verify API key
- Check API quota
- Enable YouTube Data API v3

## Best Practices

1. **Review Content**: Always review generated content before publishing
2. **A/B Test**: Test different topics and styles
3. **Monitor Performance**: Track views and engagement
4. **Update Regularly**: Keep topics fresh and relevant
5. **Stay Compliant**: Follow YouTube's community guidelines

## Future Enhancements

- [ ] Real-time market data integration
- [ ] AI-powered video generation
- [ ] Automated thumbnail creation
- [ ] Social media posting
- [ ] Analytics dashboard
- [ ] Multi-language support

## Legal Disclaimer

This system is for educational purposes only. Always:
- Verify financial information
- Follow YouTube's policies
- Include proper disclaimers
- Don't provide personalized financial advice

## Support

For issues or questions:
1. Check logs in `logs/` directory
2. Review error messages
3. Verify configuration
4. Check API quotas

## License

MIT License - Feel free to use and modify for your own projects.

## Credits

- Open-source models and APIs
- Free tools and resources
- Community contributions

---

**Note**: This is a demonstration system. For production use, review and validate all content before publishing.
