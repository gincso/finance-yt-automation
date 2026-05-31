# Finance YouTube Automation

Automated faceless YouTube channel system for finance videos using multi-agent architecture and free LLMs.

## 🚀 Features

- **Multi-Agent System**: Content Researcher, Writer, Video Creator, and Uploader agents
- **Zero Startup Cost**: Uses free LLMs and open-source tools
- **50+ Topics**: Covers budgeting, investing, crypto, retirement, real estate, debt management, and passive income
- **Daily Automation**: Cron job configured for daily video creation at 9:00 AM UTC
- **Ready to Run**: Complete, runnable system with mock implementations

## 📁 Project Structure

```
finance-yt-automation/
├── agents/
│   ├── researcher.py      # Researches finance topics
│   ├── writer.py          # Creates video scripts
│   ├── video_creator.py   # Generates videos
│   └── uploader.py        # Uploads to YouTube
├── scripts/
│   ├── setup.sh           # Installation script
│   └── run_daily.py       # Daily automation script
├── config/
│   └── config.yaml        # Main configuration
├── data/
│   ├── videos/            # Generated videos
│   ├── scripts/           # Generated scripts
│   ├── audio/             # Generated audio
│   ├── thumbnails/        # Generated thumbnails
│   └── uploads/           # Uploaded videos
├── logs/                  # Automation logs
├── main.py                # Main orchestrator
├── requirements.txt       # Python dependencies
└── README.md              # This file
```

## 🛠️ Installation

### 1. Install Dependencies

```bash
cd ~/finance-yt-automation
pip install -r requirements.txt
```

### 2. Configure API Keys

Edit `config/config.yaml` and add your API keys:

```yaml
huggingface:
  api_token: "YOUR_HUGGINGFACE_TOKEN"  # Get free token at https://huggingface.co/settings/tokens

youtube:
  enabled: true
  client_id: "YOUR_YOUTUBE_CLIENT_ID"
  client_secret: "YOUR_YOUTUBE_CLIENT_SECRET"
```

### 3. Set Up Cron Job (Daily Automation)

```bash
crontab -e
```

Add this line for daily runs at 9:00 AM UTC:

```
0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && python main.py >> logs/cron.log 2>&1
```

## 🎯 Usage

### Run Once

```bash
cd ~/finance-yt-automation
python main.py
```

### Run with Specific Topic

Edit `main.py` to select a specific topic, or modify the `select_topic()` method.

### Check Logs

```bash
tail -f logs/automation.log
```

## 📊 How It Works

1. **Research Agent**: Selects a finance topic and gathers relevant information
2. **Writer Agent**: Creates an engaging video script based on research
3. **Video Creator Agent**: Generates audio from script and creates video file
4. **Uploader Agent**: Uploads video to YouTube (when configured)

## 🎨 Supported Topics

- **Budgeting**: Budgeting for Beginners, Monthly Budget, Zero-Based Budgeting, Emergency Fund
- **Investing**: Stock Market, Dollar-Cost Averaging, Dividend Investing, ETF vs Individual Stocks
- **Crypto**: Cryptocurrency, Bitcoin vs Ethereum, How to Buy Crypto, Stablecoins, Wallet Security
- **Retirement**: Retirement Planning, 401(k) vs IRA, Retirement Savings, Social Security
- **Real Estate**: Real Estate Investing, Rental Property vs REITs, Investment Properties, Tax Benefits
- **Debt Management**: Debt Snowball vs Avalanche, Credit Card Debt, Student Loans, Debt Consolidation
- **Passive Income**: 10 Passive Income Ideas, Dividend Stocks, Real Estate Crowdfunding, Digital Products

## 🔧 Configuration

Edit `config/config.yaml` to customize:

- Agent models and settings
- Topics list
- Scheduling (time, timezone, frequency)
- Output directories
- API keys

## 📝 Current Status

- ✅ Complete project structure
- ✅ Multi-agent architecture
- ✅ Mock implementations (ready for API integration)
- ✅ Configuration system
- ✅ Logging system
- ✅ Documentation
- ⏳ Ready for production (needs API keys and real implementations)

## 🚀 Next Steps

1. **Add API Keys**: Get Hugging Face token and YouTube credentials
2. **Implement Real LLM Calls**: Replace mock implementations with actual API calls
3. **Add Video Processing**: Integrate FFmpeg for actual video generation
4. **Configure YouTube Upload**: Set up YouTube Data API
5. **Test Thoroughly**: Run multiple times to verify workflow
6. **Monitor and Optimize**: Check logs and improve performance

## 📚 Resources

- [Hugging Face API](https://huggingface.co/docs/api-inference)
- [YouTube Data API](https://developers.google.com/youtube/v3)
- [FFmpeg](https://ffmpeg.org/)

## 💡 Tips

- Start with a few topics to test the workflow
- Monitor logs regularly for issues
- Adjust script length and complexity based on results
- Use A/B testing to find best-performing topics
- Consider adding more topics over time

## 📄 License

MIT License - feel free to use and modify for your own projects.

## 🤝 Contributing

This is a starter project. Feel free to enhance it with:
- Real LLM API integrations
- Better video generation
- Advanced scheduling
- Analytics and reporting
- Multiple channel support

## 📞 Support

For issues or questions:
1. Check logs in `logs/` directory
2. Review configuration in `config/config.yaml`
3. Refer to this README

---

**Built with ❤️ for automated content creation**
