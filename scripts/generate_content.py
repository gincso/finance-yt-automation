#!/usr/bin/env python3
"""
Finance Content Generator
Uses free LLMs to generate engaging finance content for YouTube videos
"""

import os
import json
import random
from typing import Dict, List, Optional
import requests
import time

class ContentGenerator:
    def __init__(self, config_path: str):
        self.config = self.load_config(config_path)
        self.llm_config = self.config['ai_models']['llm']
        
    def load_config(self, config_path: str) -> Dict:
        """Load configuration from YAML file"""
        import yaml
        with open(config_path, 'r') as f:
            return yaml.safe_load(f)
    
    def get_topic(self, category: Optional[str] = None) -> Dict:
        """Select a random finance topic"""
        if category:
            topics = [t for t in self.config['finance_topics'] if t['category'] == category]
        else:
            topics = self.config['finance_topics']
        
        return random.choice(topics)
    
    def generate_script(self, topic: Dict, script_type: str = "explanatory") -> Dict:
        """Generate a video script using LLM"""
        
        system_prompt = f"""You are an expert finance content creator specializing in creating engaging YouTube videos.
        
Your task is to create a {script_type} script about: {topic['title']}
Category: {topic['category']}
Difficulty: {topic['difficulty']}
Estimated Duration: {topic['estimated_duration']}
Keywords: {', '.join(topic['keywords'])}

Requirements:
1. Hook: Create an engaging opening (3-5 seconds)
2. Body: 3-5 key points explained clearly
3. Call to Action: Encourage engagement at the end
4. Keep it conversational but educational
5. Use simple language appropriate for {topic['difficulty']} level
6. Include practical examples and actionable advice
7. Keep total duration around {topic['estimated_duration']}"""

        user_prompt = f"""Create a YouTube video script about: {topic['title']}
Description: {topic['description']}
Keywords: {', '.join(topic['keywords'])}
Script Type: {script_type}

Please provide:
1. Title
2. Script with timestamps
3. Key points to cover
4. Suggested visuals
5. Call to action"""

        try:
            # Using Hugging Face Inference API (free tier available)
            headers = {
                "Authorization": f"Bearer {os.environ.get('HUGGINGFACE_TOKEN', '')}",
                "Content-Type": "application/json"
            }
            
            payload = {
                "inputs": user_prompt,
                "parameters": {
                    "max_new_tokens": 800,
                    "temperature": 0.7,
                    "top_p": 0.9
                }
            }
            
            response = requests.post(
                self.llm_config['api_base'],
                headers=headers,
                json=payload,
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                script_content = result[0]['generated_text'] if isinstance(result, list) else result.get('generated_text', '')
                
                return {
                    "title": topic['title'],
                    "description": topic['description'],
                    "keywords": topic['keywords'],
                    "content": script_content,
                    "category": topic['category'],
                    "difficulty": topic['difficulty'],
                    "estimated_duration": topic['estimated_duration'],
                    "generated_at": time.strftime("%Y-%m-%d %H:%M:%S")
                }
            else:
                print(f"LLM API Error: {response.status_code} - {response.text}")
                return self.generate_fallback_script(topic)
                
        except Exception as e:
            print(f"Error generating script: {e}")
            return self.generate_fallback_script(topic)
    
    def generate_fallback_script(self, topic: Dict) -> Dict:
        """Generate a basic script if LLM fails"""
        return {
            "title": topic['title'],
            "description": topic['description'],
            "keywords": topic['keywords'],
            "content": f"""# {topic['title']}

## Introduction (0:00-0:05)
Welcome to our channel! Today we're discussing {topic['title']}.

## Key Points (0:05-0:30)
1. First, let's understand what {topic['title']} means
2. Why it's important for your financial future
3. How you can apply this to your own situation

## Actionable Advice (0:30-0:45)
Start by researching more about this topic
Consider how it fits into your overall financial plan
Take small steps toward implementing these strategies

## Conclusion (0:45-0:50)
Thanks for watching! Like and subscribe for more finance content.
Follow us on social media for daily tips and updates.""",
            "category": topic['category'],
            "difficulty": topic['difficulty'],
            "estimated_duration": topic['estimated_duration'],
            "generated_at": time.strftime("%Y-%m-%d %H:%M:%S")
        }
    
    def generate_video_description(self, script: Dict) -> str:
        """Generate optimized YouTube description"""
        return f"""{script['description']}

## Key Takeaways:
• {', '.join(script['keywords'][:3])}
• Suitable for {script['difficulty']} level investors
• Estimated video duration: {script['estimated_duration']}

## Subscribe for More:
Follow our channel for daily finance tips and insights!

#finance #investing #money #wealth #personalfinance #investingtips #stocks #crypto #budgeting #financialfreedom"""

    def save_script(self, script: Dict, output_dir: str):
        """Save generated script to file"""
        os.makedirs(output_dir, exist_ok=True)
        
        filename = f"{script['title'].replace(' ', '_').lower()}.json"
        filepath = os.path.join(output_dir, filename)
        
        with open(filepath, 'w') as f:
            json.dump(script, f, indent=2)
        
        print(f"Script saved to: {filepath}")
        return filepath

# Example usage
if __name__ == "__main__":
    config_path = "/data/data/com.termux/files/home/finance-yt-automation/config/config.yaml"
    
    generator = ContentGenerator(config_path)
    
    # Generate a script for a personal finance topic
    topic = generator.get_topic("Personal Finance")
    script = generator.generate_script(topic)
    
    print(f"\nGenerated Script for: {script['title']}")
    print(f"Category: {script['category']}")
    print(f"Difficulty: {script['difficulty']}")
    print(f"\nContent preview:\n{script['content'][:500]}...")
    
    # Save the script
    generator.save_script(script, "/data/data/com.termux/files/home/finance-yt-automation/content/scripts")
