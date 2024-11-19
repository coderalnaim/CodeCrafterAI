#!/bin/bash

echo "Setting up your environment..."

# Step 1: Create a virtual environment
python -m venv venv

# Step 2: Activate the virtual environment
source venv/bin/activate

# Step 3: Install required packages
pip install -r requirements.txt

echo "Setup complete! Use './run.sh' to launch the app."
