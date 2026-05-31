#!/bin/bash
# Daily automation script

cd /data/data/com.termux/files/home/finance-yt-automation

# Create logs directory if it doesn't exist
mkdir -p logs

# Run the main script
python main.py >> logs/cron.log 2>&1

# Check exit code
if [ $? -eq 0 ]; then
    echo "✅ Automation completed successfully"
else
    echo "❌ Automation failed"
fi
