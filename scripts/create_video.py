#!/usr/bin/env python3
"""
Video Creator for Finance YouTube Channel
Creates videos from generated scripts using open-source tools
"""

import os
import json
import subprocess
import textwrap
from typing import Dict, List
from datetime import datetime

class VideoCreator:
    def __init__(self, config_path: str):
        self.config = self.load_config(config_path)
        self.video_config = self.config['video_creation']
        
    def load_config(self, config_path: str) -> Dict:
        """Load configuration from YAML file"""
        import yaml
        with open(config_path, 'r') as f:
            return yaml.safe_load(f)
    
    def create_video_structure(self, script: Dict, output_dir: str) -> Dict:
        """Create the directory structure for video creation"""
        os.makedirs(output_dir, exist_ok=True)
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        video_id = f"{timestamp}_{script['title'].replace(' ', '_').lower()[:30]}"
        
        structure = {
            "video_id": video_id,
            "title": script['title'],
            "output_dir": output_dir,
            "scenes": [],
            "duration": self.parse_duration(script['estimated_duration'])
        }
        
        return structure
    
    def parse_duration(self, duration_str: str) -> int:
        """Convert duration string to seconds"""
        try:
            if "-" in duration_str:
                parts = duration_str.split("-")
                return int(parts[0].strip())
            else:
                return int(duration_str.split()[0])
        except:
            return 30  # Default 30 seconds
    
    def split_script_into_scenes(self, script_content: str) -> List[Dict]:
        """Split script into scenes with timestamps"""
        scenes = []
        
        # Simple heuristic: split by headings
        lines = script_content.split('\n')
        current_scene = None
        
        for line in lines:
            line = line.strip()
            if line.startswith('#'):
                if current_scene:
                    scenes.append(current_scene)
                current_scene = {
                    "title": line.lstrip('#').strip(),
                    "content": [],
                    "start_time": 0,
                    "end_time": 0
                }
            elif line and not line.startswith('#') and current_scene:
                current_scene["content"].append(line)
        
        if current_scene:
            scenes.append(current_scene)
        
        # Assign timestamps based on content length
        total_duration = scenes[-1]['end_time'] if scenes else 30
        scene_duration = total_duration / len(scenes) if scenes else 10
        
        for i, scene in enumerate(scenes):
            scene["start_time"] = int(i * scene_duration)
            scene["end_time"] = int((i + 1) * scene_duration)
            scene["content"] = '\n'.join(scene["content"])
        
        return scenes
    
    def generate_scene_descriptions(self, script: Dict) -> List[Dict]:
        """Generate scene descriptions and visual suggestions"""
        scenes = self.split_script_into_scenes(script['content'])
        
        visual_templates = [
            "Clean background with charts and graphs",
            "Text overlays with key points",
            "Animated charts showing financial data",
            "Simple animations explaining concepts",
            "Stock market screens with relevant data",
            "Savings calculator visualization",
            "Budget breakdown graphics",
            "Investment growth charts"
        ]
        
        for scene in scenes:
            scene["visual_style"] = random.choice(visual_templates)
            scene["text_overlays"] = [
                line.strip() for line in scene["content"].split('\n')[:5]
                if line.strip() and not line.startswith('#')
            ]
        
        return scenes
    
    def create_video_using_ffmpeg(self, scenes: List[Dict], output_path: str) -> bool:
        """Create video using FFmpeg with simple animations"""
        try:
            # Create a simple video using FFmpeg
            # This creates a video with changing background colors and text
            
            # Create a temporary directory for assets
            temp_dir = output_path.replace('.mp4', '_temp')
            os.makedirs(temp_dir, exist_ok=True)
            
            # Create a simple animated background
            # (In production, this would use more sophisticated tools)
            
            # For now, create a basic video structure
            # This is a placeholder - real implementation would use:
            # - Text-to-video AI models
            # - Stock footage
            # - Motion graphics
            
            print(f"Video structure created for {len(scenes)} scenes")
            print(f"Output path: {output_path}")
            
            # Create a placeholder video file
            # In production, integrate with:
            # - Stable Video Diffusion (open-source video generation)
            # - RunwayML (free tier available)
            # - Pika Labs
            # - HeyGen (free tier available)
            
            return True
            
        except Exception as e:
            print(f"Error creating video: {e}")
            return False
    
    def generate_video_metadata(self, script: Dict, scenes: List[Dict]) -> Dict:
        """Generate video metadata for YouTube upload"""
        return {
            "title": script['title'],
            "description": self.config['youtube']['optimization']['tags'] + [script['title']],
            "tags": self.config['youtube']['optimization']['tags'] + script['keywords'],
            "category": self.config['youtube']['optimization']['category'],
            "language": "en",
            "privacy_status": "public",
            "video_id": scenes[0]['video_id'] if scenes else "unknown"
        }
    
    def save_video_metadata(self, metadata: Dict, output_dir: str):
        """Save video metadata to file"""
        os.makedirs(output_dir, exist_ok=True)
        
        filename = f"{metadata['video_id']}_metadata.json"
        filepath = os.path.join(output_dir, filename)
        
        with open(filepath, 'w') as f:
            json.dump(metadata, f, indent=2)
        
        print(f"Metadata saved to: {filepath}")
        return filepath

# Example usage
if __name__ == "__main__":
    config_path = "/data/data/com.termux/files/home/finance-yt-automation/config/config.yaml"
    
    creator = VideoCreator(config_path)
    
    # Sample script content
    sample_script = {
        "title": "The 50/30/20 Budget Rule Explained",
        "content": """# The 50/30/20 Budget Rule Explained

## Introduction
The 50/30/20 budget rule is a simple framework for managing your money effectively.

## Key Points
50% of income goes to needs
30% goes to wants
20% goes to savings and debt payments

## Benefits
Reduces financial stress
Builds savings
Prevents overspending

## How to Apply
Calculate your income
Divide into 50/30/20
Track your spending
Adjust as needed

## Conclusion
Start small and build habits that last a lifetime.""",
        "estimated_duration": "3-4 minutes"
    }
    
    # Create video structure
    structure = creator.create_video_structure(sample_script, "/data/data/com.termux/files/home/finance-yt-automation/output/videos")
    
    # Generate scene descriptions
    scenes = creator.generate_scene_descriptions(sample_script)
    
    print(f"\nCreated {len(scenes)} scenes:")
    for i, scene in enumerate(scenes):
        print(f"Scene {i+1}: {scene['title']}")
        print(f"  Duration: {scene['start_time']}-{scene['end_time']} seconds")
        print(f"  Visual: {scene['visual_style']}")
        print(f"  Content: {scene['content'][:100]}...")
        print()
