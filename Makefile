# Makefile for Finance YouTube Automation Docker

.PHONY: help build up down restart logs ps clean shell test

# Default target
help:
	@echo "Finance YouTube Automation - Docker Makefile"
	@echo ""
	@echo "Available commands:"
	@echo "  make build        - Build Docker image"
	@echo "  make up           - Start container"
	@echo "  make up-d         - Start container in background"
	@echo "  make down         - Stop and remove container"
	@echo "  make restart      - Restart container"
	@echo "  make logs         - Show logs"
	@echo "  make logs-f       - Follow logs"
	@echo "  make ps           - Show container status"
	@echo "  make shell        - Enter container shell"
	@echo "  make clean        - Remove container and volumes"
	@echo "  make test         - Run automation once"
	@echo "  make install      - Install dependencies"
	@echo ""

build:
	@echo "Building Docker image..."
	docker-compose build

up:
	@echo "Starting container..."
	docker-compose up -d

up-d:
	@echo "Starting container in background..."
	docker-compose up -d

down:
	@echo "Stopping container..."
	docker-compose down

restart:
	@echo "Restarting container..."
	docker-compose restart

logs:
	@echo "Showing logs..."
	docker-compose logs

logs-f:
	@echo "Following logs..."
	docker-compose logs -f

ps:
	@echo "Container status:"
	docker-compose ps

shell:
	@echo "Entering container shell..."
	docker-compose exec finance-yt-automation sh

clean:
	@echo "Cleaning up..."
	docker-compose down -v
	docker rmi finance-yt-automation:latest 2>/dev/null || true
	@echo "Clean complete"

test:
	@echo "Running automation once..."
	docker-compose run --rm finance-yt-automation

install:
	@echo "Installing dependencies..."
	docker-compose run --rm finance-yt-automation pip3 install -r requirements.txt

# Cron job setup
cron-add:
	@echo "Adding cron job (runs daily at 9:00 AM UTC)..."
	@echo "0 9 * * * cd /data/data/com.termux/files/home/finance-yt-automation && docker-compose run --rm finance-yt-automation >> logs/cron.log 2>&1" | crontab -

cron-remove:
	@echo "Removing cron job..."
	crontab -l | grep -v "finance-yt-automation" | crontab -
	@echo "Cron job removed"

cron-list:
	@echo "Current cron jobs:"
	crontab -l

# Environment setup
setup-env:
	@echo "Setting up environment..."
	@if [ ! -f .env ]; then \
		echo "HUGGINGFACE_API_TOKEN=" > .env; \
		echo "YOUTUBE_CLIENT_ID=" >> .env; \
		echo "YOUTUBE_CLIENT_SECRET=" >> .env; \
		echo "TZ=UTC" >> .env; \
		echo "Created .env file. Edit it with your API keys."; \
	else \
		echo ".env file already exists."; \
	fi

# Config setup
setup-config:
	@echo "Setting up config file..."
	@if [ ! -f config/config.yaml ]; then \
		cp config/config.yaml.example config/config.yaml; \
		echo "Created config/config.yaml from example. Edit it with your settings."; \
	else \
		echo "config/config.yaml already exists."; \
	fi
