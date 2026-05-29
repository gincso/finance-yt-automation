#!/usr/bin/env python3
"""
Main Automation Orchestrator for Finance YouTube Channel
Multi-agent system that manages content creation pipeline
"""

import os
import sys
import json
import time
import subprocess
from datetime import datetime, timedelta
from typing import Dict, List, Optional
from pathlib import Path

# Add scripts directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from generate_content import ContentGenerator
from create_video import VideoCreator

class AutomationOrchestrator:
    def __init__(self, config_path: str):
        self.config = self.load_config(config_path)
        self.content_gen = ContentGenerator(config_path)
        self.video_creator = VideoCreator(config_path)
        self.log_file = os.path.join(
            self.config['automation']['log_dir'], 
            f"automation_{datetime.now().strftime('%Y%m%d')}.log"
        )
        
    def load_config(self, config_path: str) -> Dict:
        """Load configuration"""
        with open(config_path, 'r') as f:
            return json.load(f)
    
    def log(self, message: str, level: str = "INFO"):
        """Log messages to file and console"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_entry = f"[{timestamp}] [{level}] {message}\n"
        
        print(log_entry.strip())
        
        with open(self.log_file, 'a') as f:
            f.write(log_entry)
    
    def agent_content_researcher(self):
        """Agent 1: Content Researcher"""
        self.log("Starting Content Researcher agent...")
        
        topics = self.config['finance_topics'] + self.config['trending_topics']
        selected_topic = self.content_gen.get_topic()
        
        self.log(f"Selected topic: {selected_topic['title']}")
        self.log(f"Category: {selected_topic['category']}")
        
        return selected_topic
    
    def agent_content_writer(self, topic: Dict) -> Dict:
        """Agent 2: Content Writer"""
        self.log("Starting Content Writer agent...")
        self.log(f"Writing script for: {topic['title']}")
        
        script = self.content_gen.generate_script(topic, "explanatory")
        
        self.log(f"Script generated successfully")
        self.log(f"Duration: {script['estimated_duration']}")
        
        return script
    
    def agent_video_creator(self, script: Dict) -> Dict:
        """Agent 3: Video Creator"""
        self.log("Starting Video Creator agent...")
        self.log(f"Creating video for: {script['title']}")
        
        # Create video structure
        structure = self.video_creator.create_video_structure(script, "/data/data/com.termux/files/home/finance-yt-automation/output/videos")
        
        # Generate scene descriptions
        scenes = self.video_creator.generate_scene_descriptions(script)
        
        self.log(f"Created {len(scenes)} scenes")
        for i, scene in enumerate(scenes):
            self.log(f"  Scene {i+1}: {scene['title']} ({scene['start_time']}-{scene['end_time']}s)")
        
        return {
            "script": script,
            "scenes": scenes,
            "structure": structure
        }
    
    def agent_uploader(self, video_data: Dict) -> Dict:
        """Agent 4: Uploader (placeholder for YouTube API integration)"""
        self.log("Starting Uploader agent...")
        self.log(f"Preparing video for upload: {video_data['script']['title']}")
        
        metadata = self.video_creator.generate_video_metadata(
            video_data['script'],
            video_data['scenes']
        )
        
        self.log(f"Generated metadata:")
        self.log(f"  Title: {metadata['title']}")
        self.log(f"  Tags: {', '.join(metadata['tags'][:5])}...")
        
        return metadata
    
    def run_single_video_workflow(self) -> Dict:
        """Execute complete workflow for one video"""
        self.log("=" * 60)
        self.log("Starting new video creation workflow")
        self.log("=" * 60)
        
        try:
            # Agent 1: Content Researcher
            topic = self.agent_content_researcher()
            
            # Agent 2: Content Writer
            script = self.agent_content_writer(topic)
            
            # Save script
            script_path = self.content_gen.save_script(script, "/data/data/com.termux/files/home/finance-yt-automation/content/scripts")
            self.log(f"Script saved to: {script_path}")
            
            # Agent 3: Video Creator
            video_data = self.agent_video_creator(script)
            
            # Agent 4: Uploader
            metadata = self.agent_uploader(video_data)
            
            # Save metadata
            metadata_path = self.video_creator.save_video_metadata(
                metadata, 
                "/data/data/com.termux/files/home/finance-yt-automation/output/videos"
            )
            self.log(f"Metadata saved to: {metadata_path}")
            
            # Save complete workflow data
            workflow_data = {
                "timestamp": datetime.now().isoformat(),
                "topic": topic,
                "script": script,
                "scenes": video_data['scenes'],
                "metadata": metadata
            }
            
            workflow_path = os.path.join(
                "/data/data/com.termux/files/home/finance-yt-automation/output/videos",
                f"{metadata['video_id']}_workflow.json"
            )
            
            with open(workflow_path, 'w') as f:
                json.dump(workflow_data, f, indent=2)
            
            self.log(f"Workflow saved to: {workflow_path}")
            
            self.log("=" * 60)
            self.log("Workflow completed successfully!")
            self.log("=" * 60)
            
            return {
                "status": "success",
                "video_id": metadata['video_id'],
                "title": metadata['title'],
                "script_path": script_path,
                "metadata_path": metadata_path
            }
            
        except Exception as e:
            self.log(f"Error in workflow: {e}", "ERROR")
            return {
                "status": "error",
                "error": str(e)
            }
    
    def run_batch_workflow(self, count: int = 5):
        """Run multiple videos in batch"""
        results = []
        
        for i in range(count):
            self.log(f"\n--- Batch Video {i+1}/{count} ---\n")
            result = self.run_single_video_workflow()
            results.append(result)
            
            if i < count - 1:
                wait_time = self.config['automation']['schedule']['videos_per_day'] * 3600
                self.log(f"Waiting {wait_time} seconds before next video...")
                time.sleep(wait_time)
        
        # Save batch results
        batch_results_path = os.path.join(
            "/data/data/com.termux/files/home/finance-yt-automation/output",
            f"batch_results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        )
        
        with open(batch_results_path, 'w') as f:
            json.dump(results, f, indent=2)
        
        self.log(f"\nBatch results saved to: {batch_results_path}")
        
        return results
    
    def run_continuous_mode(self):
        """Run in continuous mode with scheduling"""
        self.log("Starting continuous mode...")
        
        schedule = self.config['automation']['schedule']
        
        while True:
            self.log(f"Waiting for scheduled time: {schedule['upload_time']}")
            
            # Check current time and wait until scheduled time
            current_hour = datetime.now().hour
            target_hour = int(schedule['upload_time'].split(':')[0])
            
            if current_hour >= target_hour:
                self.log("Time to create video!")
                self.run_single_video_workflow()
                
                # Wait for next scheduled time
                wait_time = 24 * 3600  # Wait 24 hours
                self.log(f"Waiting {wait_time} seconds until next scheduled time...")
                time.sleep(wait_time)
            else:
                wait_time = (target_hour - current_hour) * 3600
                time.sleep(wait_time)

# Main execution
if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Finance YouTube Channel Automation")
    parser.add_argument("--batch", type=int, default=1, help="Run batch of videos")
    parser.add_argument("--continuous", action="store_true", help="Run in continuous mode")
    parser.add_argument("--single", action="store_true", help="Run single video workflow")
    
    args = parser.parse_args()
    
    config_path = "/data/data/com.termux/files/home/finance-yt-automation/config/config.yaml"
    orchestrator = AutomationOrchestrator(config_path)
    
    try:
        if args.continuous:
            orchestrator.run_continuous_mode()
        elif args.single:
            orchestrator.run_single_video_workflow()
        elif args.batch > 1:
            orchestrator.run_batch_workflow(args.batch)
        else:
            orchestrator.run_single_video_workflow()
    except KeyboardInterrupt:
        orchestrator.log("Workflow interrupted by user", "WARNING")
        sys.exit(0)
    except Exception as e:
        orchestrator.log(f"Fatal error: {e}", "ERROR")
        sys.exit(1)
