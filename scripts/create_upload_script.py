#!/usr/bin/env python3
"""
YouTube Upload Automation Script
Automatically uploads videos to YouTube using the Data API v3
"""

import os
import sys
import json
import argparse
from datetime import datetime

# Add scripts to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

def get_latest_video(output_dir):
    """Find the latest generated video"""
    import glob
    videos = glob.glob(os.path.join(output_dir, '*.json'))
    if videos:
        return max(videos, key=os.path.getmtime)
    return None

def load_video_data(video_path):
    """Load video data from JSON file"""
    with open(video_path, 'r') as f:
        return json.load(f)

def create_youtube_upload_script(video_data, output_path):
    """Create a YouTube upload script"""

    # Escape strings for Python
    title = video_data.get('title', 'Untitled').replace("'", "\\'")
    description = video_data.get('description', '').replace("'", "\\'")
    keywords = ', '.join(video_data.get('keywords', [])[:10])

    script_content = f'''#!/usr/bin/env python3
"""
YouTube Upload Script for: {title}
Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
"""

import os
import sys
import google.auth
from google.auth.transport.requests import AuthorizedSession
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
import json

# YouTube API credentials
YOUTUBE_API_KEY="{os.environ.get('YOUTUBE_API_KEY', '')}"

def upload_video(video_data, video_file_path):
    """Upload video to YouTube"""

    # YouTube API setup
    youtube = build('youtube', 'v3', developerKey=YOUTUBE_API_KEY)

    # Video metadata
    body = {{
        'snippet': {{
            'title': '{title}',
            'description': '''{description}

## Key Takeaways:
- {', '.join(video_data.get('keywords', [])[:3])}
- Suitable for {video_data.get('difficulty', 'beginner')} level
- Estimated duration: {video_data.get('estimated_duration', 'N/A')}

## Subscribe for More:
Follow our channel for daily finance tips and insights!

#finance #investing #money #wealth #personalfinance #investingtips #stocks #crypto #budgeting #financialfreedom''',
            'tags': ['{keywords}'],
            'categoryId': '22',  # Finance category
            'defaultLanguage': 'en'
        }},
        'status': {{
            'privacyStatus': 'public',
            'selfDeclaredMadeForKids': False
        }}
    }}

    # Upload video file
    print("Uploading video to YouTube...")
    youtube.videos().insert(
        part='snippet,status',
        body=body,
        media_body=MediaFileUpload(video_file_path, chunksize=1024*1024, resumable=True)
    ).execute()

    print("Video uploaded successfully!")

if __name__ == '__main__':
    if not YOUTUBE_API_KEY:
        print("Error: YOUTUBE_API_KEY not set")
        print("Set it with: export YOUTUBE_API_KEY=***    exit(1)

    # Find latest video
    output_dir = "{os.path.join(os.path.dirname(__file__), '..', 'output', 'videos')}"
    video_path = get_latest_video(output_dir)

    if not video_path:
        print("Error: No video found")
        exit(1)

    # Load video data
    video_data = load_video_data(video_path)
    print(f"Video: {{video_data.get('title')}}")

    # Find video file (placeholder - replace with actual video file)
    video_file = "output.mp4"  # TODO: Create video file from script

    if not os.path.exists(video_file):
        print(f"Error: Video file not found: {{video_file}}")
        print("Please create video file first using FFmpeg or video AI tools")
        exit(1)

    # Upload
    upload_video(video_data, video_file)
'''

    with open(output_path, 'w') as f:
        f.write(script_content)

    os.chmod(output_path, 0o755)
    print(f"Upload script created: {output_path}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Create YouTube upload script')
    parser.add_argument('--video', help='Specific video path')
    args = parser.parse_args()

    output_dir = os.path.join(os.path.dirname(__file__), '..', 'output', 'videos')

    if args.video:
        video_path = args.video
    else:
        video_path = get_latest_video(output_dir)

    if not video_path:
        print("Error: No video found")
        exit(1)

    video_data = load_video_data(video_path)
    output_path = os.path.join(
        os.path.dirname(__file__),
        'upload_youtube.py'
    )

    create_youtube_upload_script(video_data, output_path)
    print(f"\nUpload script created for: {video_data.get('title')}")
    print(f"\nTo upload:")
    print(f"  1. Create video file from script")
    print(f"  2. Run: python3 scripts/upload_youtube.py")
