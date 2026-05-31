# Docker Setup for Finance YouTube Automation

Complete Docker setup for running the Finance YouTube Automation on Alpine Linux.

## 🐳 Prerequisites

- Docker installed: `docker --version`
- Docker Compose installed: `docker-compose --version`

## 📦 Building the Image

### Build with Docker
```bash
cd ~/finance-yt-automation
docker build -t finance-yt-automation:latest .
```

### Build with Docker Compose
```bash
cd ~/finance-yt-automation
docker-compose build
```

## ⚙️ Configuration

### Set Environment Variables

Create a `.env` file in the project root:

```bash
# Hugging Face API Token (required for real LLM calls)
HUGGINGFACE_API_TOKEN=your_token_here

# YouTube API Credentials (optional, for uploads)
YOUTUBE_CLIENT_ID=your_client_id
YOUTUBE_CLIENT_SECRET=your_client_secret

# Timezone (optional, defaults to UTC)
TZ=UTC
```

**Get a free Hugging Face token at**: https://huggingface.co/settings/tokens

**Get YouTube API credentials at**: https://console.cloud.google.com/apis/credentials

### Create Config File

Copy the example config:
```bash
cp config/config.yaml.example config/config.yaml
```

Edit `config/config.yaml` with your settings.

## 🚀 Running the Container

### Run Once
```bash
docker run --rm \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/logs:/app/logs \
  finance-yt-automation:latest
```

### Run with Environment Variables
```bash
docker run --rm \
  -e HUGGINGFACE_API_TOKEN=your_token \
  -e YOUTUBE_CLIENT_ID=your_client \
  -e YOUTUBE_CLIENT_SECRET=your_secret \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/logs:/app/logs \
  finance-yt-automation:latest
```

### Run with Docker Compose
```bash
# Build if needed
docker-compose build

# Run once
docker-compose up

# Run in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

## 🔄 Daily Automation with Cron

### Using Docker Compose

Create a cron job (runs daily at 9:00 AM UTC):

```bash
crontab -e
```

Add:
```
0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && docker-compose run --rm finance-yt-automation >> logs/cron.log 2>&1
```

### Using Docker Run

Create a cron job:
```bash
crontab -e
```

Add:
```
0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && docker run --rm -v $(pwd)/data:/app/data -v $(pwd)/logs:/app/logs finance-yt-automation:latest >> logs/cron.log 2>&1
```

## 📁 Volume Mapping

The following directories are mounted to persist data:

- `./data` → `/app/data` - Generated videos, scripts, audio, thumbnails
- `./logs` → `/app/logs` - Automation logs

## 🔍 Monitoring

### View Container Logs
```bash
# All logs
docker-compose logs

# Real-time logs
docker-compose logs -f

# Last 100 lines
docker-compose logs --tail=100
```

### Check Container Status
```bash
docker ps
docker-compose ps
```

### Inspect Container
```bash
docker inspect finance-yt-automation
```

## 🛠️ Maintenance

### Rebuild Image
```bash
docker-compose build --no-cache
```

### Clean Up
```bash
# Remove stopped containers
docker-compose down

# Remove volumes
docker-compose down -v

# Remove images
docker rmi finance-yt-automation:latest
```

### Update Configuration
```bash
# Edit config files
nano config/config.yaml
nano .env

# Restart container
docker-compose restart
```

## 🐛 Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs

# Check container status
docker-compose ps
```

### Permission issues
```bash
# Fix permissions
chmod +x scripts/*.sh
chmod +x docker-entrypoint.sh
```

### Data not persisting
```bash
# Check volume mounts
docker inspect finance-yt-automation | grep Mounts

# Ensure directories exist
mkdir -p data logs
```

### Import errors
```bash
# Reinstall dependencies
docker-compose run --rm finance-yt-automation pip3 install -r requirements.txt
```

## 📊 Docker Compose Commands

| Command | Description |
|---------|-------------|
| `docker-compose up` | Start container |
| `docker-compose up -d` | Start in background |
| `docker-compose down` | Stop and remove container |
| `docker-compose logs -f` | Follow logs |
| `docker-compose restart` | Restart container |
| `docker-compose ps` | List containers |
| `docker-compose build` | Build image |

## 🔐 Security Notes

1. **Never commit API keys** to version control
   - Use `.env` file (added to `.gitignore`)
   - Use Docker secrets for production

2. **Use environment variables** instead of mounting config files
   ```bash
   -e HUGGINGFACE_API_TOKEN=your_token
   ```

3. **Keep images updated**
   ```bash
   docker pull alpine:latest
   docker-compose build --no-cache
   ```

## 🎯 Production Deployment

### Use Docker Secrets
```bash
echo "your_token" | docker secret create hf_token -
docker run --secret hf_token ...
```

### Use Environment File
```bash
docker-compose up --env-file .env
```

### Use Reverse Proxy
```bash
# Use Nginx or Traefik to expose the service
```

### Use Kubernetes
```bash
kubectl apply -f k8s/
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Alpine Linux](https://alpinelinux.org/)
- [FFmpeg Documentation](https://ffmpeg.org/documentation.html)

## 🎊 You're Ready!

Build and run your Finance YouTube Automation in Docker:

```bash
cd ~/finance-yt-automation
docker-compose build
docker-compose up
```

Enjoy automated content creation! 🚀
