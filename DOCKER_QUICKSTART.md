# 🐳 Docker Setup - Complete Guide

Complete Docker setup for running Finance YouTube Automation on Alpine Linux.

## 📦 Quick Start

### 1. Build the Image
```bash
cd ~/finance-yt-automation
make build
```

### 2. Set Up Environment
```bash
# Create .env file
cp .env.example .env

# Edit .env and add your API keys
nano .env
```

### 3. Run Once
```bash
make test
```

### 4. Set Up Daily Automation
```bash
make cron-add
```

## 🚀 Docker Commands

| Command | Description |
|---------|-------------|
| `make build` | Build Docker image |
| `make up` | Start container |
| `make up-d` | Start in background |
| `make down` | Stop container |
| `make restart` | Restart container |
| `make logs` | Show logs |
| `make logs-f` | Follow logs |
| `make ps` | Show status |
| `make shell` | Enter container |
| `make clean` | Clean everything |
| `make test` | Run once |
| `make install` | Install deps |

## ⚙️ Configuration Files

### `.env`
Contains API keys and environment variables:
```bash
HUGGINGFACE_API_TOKEN=***
YOUTUBE_CLIENT_ID=***
YOUTUBE_CLIENT_SECRET=***
TZ=UTC
```

### `config/config.yaml`
Main configuration with topics, agents, and settings:
```bash
# Copy example
cp config/config.yaml.example config/config.yaml

# Edit with your settings
nano config/config.yaml
```

## 🔐 Getting API Keys

### Hugging Face Token
1. Go to: https://huggingface.co/settings/tokens
2. Click "New token"
3. Select "Read" permissions
4. Copy your token

### YouTube API Credentials
1. Go to: https://console.cloud.google.com/apis/credentials
2. Create credentials → OAuth client ID
3. Configure consent screen
4. Get Client ID and Client Secret

## 📊 Directory Structure

```
finance-yt-automation/
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Docker Compose configuration
├── docker-entrypoint.sh    # Container startup script
├── Makefile               # Convenient commands
├── .env.example           # Environment variables example
├── config/
│   ├── config.yaml        # Main config (create from example)
│   └── config.yaml.example # Configuration template
├── data/                  # Persistent data (mounted)
│   ├── videos/
│   ├── scripts/
│   ├── audio/
│   └── thumbnails/
└── logs/                  # Logs (mounted)
```

## 🔄 Daily Automation

### Using Makefile
```bash
# Add cron job (runs daily at 9:00 AM UTC)
make cron-add

# View cron jobs
make cron-list

# Remove cron job
make cron-remove
```

### Manual Setup
```bash
crontab -e
```

Add:
```
0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && make test >> logs/cron.log 2>&1
```

## 🐛 Troubleshooting

### Container won't start
```bash
# Check logs
make logs

# Check status
make ps
```

### Permission issues
```bash
# Fix permissions
chmod +x scripts/*.sh docker-entrypoint.sh Makefile
```

### Data not persisting
```bash
# Ensure directories exist
mkdir -p data logs
```

### Import errors
```bash
# Reinstall
make install
```

## 📚 Full Documentation

See `DOCKER.md` for complete documentation including:
- Detailed configuration
- Volume mapping
- Security notes
- Production deployment
- Troubleshooting

## 🎯 Production Deployment

### Environment Variables
```bash
# Production .env
HUGGINGFACE_API_TOKEN=***
YOUTUBE_CLIENT_ID=***
YOUTUBE_CLIENT_SECRET=***
TZ=UTC
```

### Docker Secrets (Recommended)
```bash
# Create secrets
echo "your_token" | docker secret create hf_token -

# Run with secrets
docker run --secret hf_token ...
```

### Use .env File
```bash
docker-compose up --env-file .env
```

## 🎊 You're Ready!

```bash
cd ~/finance-yt-automation

# Build
make build

# Set up config
make setup-config
make setup-env

# Run once
make test

# Set up daily automation
make cron-add

# Check logs
make logs-f
```

Enjoy automated content creation! 🚀
