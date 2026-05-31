#!/usr/bin/env python3
"""
Finance YouTube Automation - Main Orchestrator
Multi-agent system for automated faceless YouTube content creation
"""

import os
import sys
import yaml
import json
import logging
from datetime import datetime
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

from agents.researcher import ContentResearcher
from agents.writer import VideoWriter
from agents.video_creator import VideoCreator
from agents.uploader import VideoUploader

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(f"{project_root}/logs/automation.log"),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)


class FinanceAutomation:
    def __init__(self, config_path="config/config.yaml"):
        """Initialize the automation system"""
        self.config = self.load_config(config_path)
        self.setup_directories()
        self.setup_agents()
        
    def load_config(self, config_path):
        """Load configuration from YAML file"""
        try:
            with open(config_path, 'r') as f:
                config = yaml.safe_load(f)
            logger.info("Configuration loaded successfully")
            return config
        except Exception as e:
            logger.error(f"Error loading config: {e}")
            sys.exit(1)
    
    def setup_directories(self):
        """Create necessary directories"""
        output_config = self.config.get('output', {})
        for dir_path in output_config.values():
            Path(dir_path).mkdir(parents=True, exist_ok=True)
        logger.info("Directories created/verified")
    
    def setup_agents(self):
        """Initialize all agents"""
        agents_config = self.config.get('agents', {})
        
        self.researcher = ContentResearcher(
            model=agents_config['researcher']['model'],
            max_tokens=agents_config['researcher']['max_tokens'],
            temperature=agents_config['researcher']['temperature']
        )
        
        self.writer = VideoWriter(
            model=agents_config['writer']['model'],
            max_tokens=agents_config['writer']['max_tokens'],
            temperature=agents_config['writer']['temperature']
        )
        
        self.video_creator = VideoCreator(
            model=agents_config['video_creator']['model'],
            max_tokens=agents_config['video_creator']['max_tokens'],
            temperature=agents_config['video_creator']['temperature']
        )
        
        self.uploader = VideoUploader(
            enabled=self.config.get('youtube', {}).get('enabled', False)
        )
        
        logger.info("All agents initialized")
    
    def select_topic(self):
        """Select a finance topic from the topics list"""
        topics_config = self.config.get('topics', {})
        all_topics = []
        
        for category, topic_list in topics_config.items():
            for topic in topic_list:
                all_topics.append({
                    'category': category,
                    'title': topic
                })
        
        # Random selection
        import random
        selected = random.choice(all_topics)
        logger.info(f"Selected topic: {selected['category']} - {selected['title']}")
        return selected
    
    def run(self):
        """Execute the complete automation workflow"""
        logger.info("=" * 60)
        logger.info("Starting Finance YouTube Automation")
        logger.info("=" * 60)
        
        # Step 1: Research
        logger.info("\n[STEP 1] Researching topic...")
        topic = self.select_topic()
        research_data = self.researcher.research(topic)
        
        # Step 2: Write script
        logger.info("\n[STEP 2] Writing video script...")
        script = self.writer.write_script(research_data, topic)
        
        # Step 3: Create video
        logger.info("\n[STEP 3] Creating video...")
        video_path = self.video_creator.create_video(script, topic)
        
        # Step 4: Upload (optional)
        if self.uploader.enabled:
            logger.info("\n[STEP 4] Uploading video...")
            upload_result = self.uploader.upload(video_path)
        else:
            logger.info("\n[STEP 4] Skipping upload (not configured)")
        
        logger.info("\n" + "=" * 60)
        logger.info("Automation Complete!")
        logger.info("=" * 60)
        
        return {
            'topic': topic,
            'script': script,
            'video_path': video_path,
            'success': True
        }


def main():
    """Main entry point"""
    try:
        automation = FinanceAutomation()
        result = automation.run()
        
        # Save result to file
        result_file = Path(automation.config['output']['script_dir']) / "last_run.json"
        with open(result_file, 'w') as f:
            json.dump(result, f, indent=2)
        
        logger.info(f"\nResult saved to: {result_file}")
        
    except KeyboardInterrupt:
        logger.info("\n\nAutomation interrupted by user")
        sys.exit(1)
    except Exception as e:
        logger.error(f"\n\nAutomation failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
