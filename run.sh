#!/bin/bash

# Step 1: Activate the virtual environment
source venv/bin/activate

# Step 2: Prompt the user for the OpenAI API key
echo "Enter your OpenAI API key:"
read api_key

# Step 3: Set the API key as an environment variable
export OPENAI_API_KEY="$api_key"

# Step 4: Run the application
python app/main.py
