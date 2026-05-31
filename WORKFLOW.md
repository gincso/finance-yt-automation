# Finance YouTube Automation - Visual Workflow

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Finance YouTube Automation               │
│                    Multi-Agent System                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    1. Configuration Layer                    │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │   .env          │  │  config.yaml    │  │  docker-    │  │
│  │  (API Tokens)   │  │  (Settings)     │  │  compose.yml │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    2. Agent Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │  Researcher     │  │    Writer       │  │  Video      │  │
│  │  Agent          │  │  Agent          │  │  Creator    │  │
│  │                 │  │                 │  │  Agent      │  │
│  │ - Selects       │  │ - Researches    │  │ - Creates   │  │
│  │   topics        │  │   content       │  │   videos    │  │
│  │ - Gathers       │  │ - Writes       │  │ - Adds      │  │
│  │   info          │  │   scripts       │  │   visuals   │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
│         │                   │                   │            │
│         └───────────────────┴───────────────────┘            │
│                              │                              │
│                              ▼                              │
│                    ┌─────────────────┐                       │
│                    │  Uploader       │                       │
│                    │  Agent          │                       │
│                    │  (Optional)     │                       │
│                    └─────────────────┘                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    3. Output Layer                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │  Videos         │  │  Scripts        │  │  Thumbnails │  │
│  │  (MP4 files)    │  │  (TXT files)    │  │  (Images)   │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
│         │                   │                   │            │
│         └───────────────────┴───────────────────┘            │
│                              │                              │
│                              ▼                              │
│                    ┌─────────────────┐                       │
│                    │  YouTube        │                       │
│                    │  (Optional)     │                       │
│                    └─────────────────┘                       │
└─────────────────────────────────────────────────────────────┘
```

## Manual Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                     Manual Run                              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 1: Configuration                                     │
│  ├─ Check .env file (API tokens)                           │
│  ├─ Check config.yaml (settings)                           │
│  └─ Verify Docker setup (if using Docker)                  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 2: Run Automation                                    │
│  └─ docker-compose run --rm finance-yt-automation python3  │
│        main.py                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 3: Monitor Progress                                  │
│  ├─ Check logs: docker-compose logs -f                     │
│  ├─ Watch terminal output                                  │
│  └─ Monitor resource usage: docker stats                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 4: Review Output                                     │
│  ├─ Check videos: ls -lh output/videos/                    │
│  ├─ View scripts: cat output/scripts/last_script.txt       │
│  └─ Check status: cat output/videos/last_run.json          │
└─────────────────────────────────────────────────────────────┘
```

## Daily Automation Workflow

```
┌─────────────────────────────────────────────────────────────┐
│              Daily Cron Job (9:00 AM UTC)                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Cron Trigger                                              │
│  └─ crontab executes:                                      │
│    docker-compose run --rm finance-yt-automation python3   │
│    main.py                                                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Container Execution                                        │
│  ├─ Load environment variables (.env)                      │
│  ├─ Load configuration (config.yaml)                       │
│  ├─ Initialize agents                                      │
│  └─ Run automation                                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Agent Processing                                           │
│  ├─ 1. Researcher Agent                                    │
│  │   ├─ Select topic from config.yaml                      │
│  │   ├─ Query LLM for research                            │
│  │   └─ Return research data                               │
│  │                                                          │
│  ├─ 2. Writer Agent                                        │
│  │   ├─ Receive research data                              │
│  │   ├─ Generate video script                              │
│  │   └─ Return script                                      │
│  │                                                          │
│  ├─ 3. Video Creator Agent                                 │
│  │   ├─ Receive script                                      │
│  │   ├─ Generate voiceover                                 │
│  │   ├─ Create visuals                                     │
│  │   ├─ Add background music                               │
│  │   ├─ Generate subtitles                                 │
│  │   └─ Create video file                                  │
│  │                                                          │
│  └─ 4. Uploader Agent (Optional)                           │
│      ├─ Receive video file                                 │
│      ├─ Upload to YouTube                                  │
│      └─ Return upload result                               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Logging & Output                                           │
│  ├─ Log to: logs/automation.log                            │
│  ├─ Save to: output/videos/last_run.json                   │
│  └─ Save video to: output/videos/[title].mp4               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Next Day                                                   │
│  └─ Cron job repeats at 9:00 AM UTC                         │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
┌──────────────┐
│  User Input  │
│              │
│  - Run       │
│  - Configure │
│  - Monitor   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Configuration│
│              │
│  - .env      │
│  - config.yaml│
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Agents     │
│              │
│  - Researcher│
│  - Writer    │
│  - Creator   │
│  - Uploader  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   LLM APIs   │
│              │
│  - HuggingFace│
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Outputs    │
│              │
│  - Videos    │
│  - Scripts   │
│  - Thumbnails│
│  - Logs      │
└──────────────┘
```

## Directory Structure

```
finance-yt-automation/
│
├── .env                    # Environment variables (API tokens)
├── .env.example            # Environment template
│
├── config/
│   ├── config.yaml         # Main configuration
│   └── config.yaml.example # Configuration template
│
├── agents/
│   ├── researcher.py       # Content research agent
│   ├── writer.py           # Script writing agent
│   ├── video_creator.py    # Video creation agent
│   └── uploader.py         # YouTube upload agent
│
├── scripts/
│   ├── setup.sh            # Setup script
│   ├── run_daily.sh        # Daily run script
│   └── setup_docker.sh     # Docker setup script
│
├── data/
│   ├── videos/             # Generated videos (mounted)
│   ├── scripts/            # Generated scripts (mounted)
│   ├── audio/              # Audio files (mounted)
│   ├── thumbnails/         # Thumbnails (mounted)
│   └── uploads/            # YouTube uploads (mounted)
│
├── logs/
│   └── automation.log      # Main log file (mounted)
│
├── output/
│   ├── videos/             # Output videos (mounted)
│   └── last_run.json       # Last run status
│
├── main.py                 # Main orchestrator
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Docker orchestration
├── docker-setup.sh         # Automated setup script
│
├── README.md               # Main documentation
├── USAGE_GUIDE.md          # Detailed usage guide
├── QUICK_REFERENCE.md      # Quick reference
├── DOCKER_DEPLOYMENT.md    # Docker deployment guide
├── DOCKER_TROUBLESHOOTING.md # Troubleshooting guide
└── WORKFLOW.md             # This file
```

## Resource Usage

```
┌─────────────────────────────────────────────────────────────┐
│                    Resource Requirements                     │
└─────────────────────────────────────────────────────────────┘

CPU Usage:
┌─────────────────────────────────────────────────────────────┐
│  Researcher:    10-20%                                      │
│  Writer:         15-25%                                      │
│  Video Creator:  60-80% (peak during video generation)      │
│  Uploader:       5-10%                                       │
│  Total:          90-135%                                     │
└─────────────────────────────────────────────────────────────┘

Memory Usage:
┌─────────────────────────────────────────────────────────────┐
│  Researcher:    512MB                                       │
│  Writer:         768MB                                       │
│  Video Creator:  1-2GB (peak during video generation)       │
│  Uploader:       256MB                                       │
│  Total:          2-4GB (with Docker)                        │
└─────────────────────────────────────────────────────────────┘

Disk Usage:
┌─────────────────────────────────────────────────────────────┐
│  Video file:    50-150MB per video                          │
│  Script file:   <1KB per script                             │
│  Log file:      1-10MB per day                              │
│  Total per day: ~150MB (video) + ~10MB (logs)               │
└─────────────────────────────────────────────────────────────┘

Time per Video:
┌─────────────────────────────────────────────────────────────┐
│  Research:      30-60 seconds                               │
│  Writing:       1-2 minutes                                 │
│  Video Creation: 5-15 minutes (depends on complexity)       │
│  Upload:         1-2 minutes (optional)                     │
│  Total:          7-20 minutes per video                     │
└─────────────────────────────────────────────────────────────┘
```

## Success Indicators

```
┌─────────────────────────────────────────────────────────────┐
│                    Success Indicators                        │
└─────────────────────────────────────────────────────────────┘

✓ Container running
├─ docker-compose ps shows "Up"
├─ Container health is "healthy"
└─ No restart loops

✓ Configuration valid
├─ .env file has valid API tokens
├─ config.yaml syntax is correct
└─ Docker Compose config is valid

✓ Video created
├─ output/videos/ contains MP4 files
├─ Video file size > 1MB
├─ Video duration > 1 minute
└─ Video can be played

✓ Logs show progress
├─ Researcher agent initialized
├─ Writer agent created script
├─ Video Creator generated video
└─ No ERROR messages

✓ Output files present
├─ output/videos/[title].mp4
├─ output/scripts/[title].txt
├─ output/thumbnails/[title].png
└─ output/videos/last_run.json
```

## Common Operations Flow

```
┌─────────────────────────────────────────────────────────────┐
│              Manual One-Time Run                            │
└─────────────────────────────────────────────────────────────┘

1. Setup
   ├─ cd ~/finance-yt-automation
   ├─ ./docker-setup.sh (if needed)
   └─ Edit .env (if needed)

2. Run
   └─ docker-compose run --rm finance-yt-automation python3 main.py

3. Monitor
   ├─ Watch terminal output
   ├─ Check logs: docker-compose logs -f
   └─ Monitor resources: docker stats

4. Review
   ├─ Check videos: ls -lh output/videos/
   ├─ View scripts: cat output/scripts/last_script.txt
   └─ Check status: cat output/videos/last_run.json

5. Repeat
   └─ Run again for more videos
```

```
┌─────────────────────────────────────────────────────────────┐
│              Daily Automated Run                            │
└─────────────────────────────────────────────────────────────┘

1. Setup Cron Job
   ├─ crontab -e
   ├─ Add: 0 9 * * * cd ~/finance-yt-automation && docker-compose run --rm finance-yt-automation python3 main.py
   └─ Save and exit

2. Test Cron Job (optional)
   ├─ Run manually once
   └─ Verify logs look correct

3. Wait for Next Run
   ├─ Cron triggers at 9:00 AM UTC
   ├─ Container starts automatically
   ├─ Runs automation
   └─ Container stops (or keeps running)

4. Check Results
   ├─ View logs: docker-compose logs --tail=50
   ├─ Check videos: ls -lh output/videos/
   └─ Monitor resources: docker stats

5. Repeat Daily
   └─ New video created automatically
```

---

**For more details, see:**
- `USAGE_GUIDE.md` - Complete usage instructions
- `QUICK_REFERENCE.md` - Quick command reference
- `DOCKER_DEPLOYMENT.md` - Docker deployment guide
- `DOCKER_TROUBLESHOOTING.md` - Troubleshooting help
