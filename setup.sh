#!/bin/bash

echo "Setting up your environment..."

# Set the script's directory as the working directory
BASE_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$BASE_DIR" || { echo "Failed to change directory to $BASE_DIR. Exiting."; exit 1; }

echo "Using working directory: $(pwd)"

# Check for Python or Python3
if command -v python3 &>/dev/null; then
    PYTHON_EXECUTABLE="python3"
elif command -v python &>/dev/null; then
    PYTHON_EXECUTABLE="python"
else
    echo "Error: Python is not installed. Please install Python 3.8 or later."
    exit 1
fi

echo "Using Python executable: $PYTHON_EXECUTABLE"

# Step 1: Create a virtual environment
$PYTHON_EXECUTABLE -m venv venv

# Step 2: Activate the virtual environment
source venv/bin/activate || { echo "Failed to activate virtual environment. Exiting."; exit 1; }

# Step 3: Upgrade pip to the latest version
pip install --upgrade pip

# Step 4: Install required packages
if [ -f requirements.txt ]; then
    pip install -r requirements.txt
else
    echo "Error: requirements.txt not found. Please ensure it exists in the project root."
    deactivate
    exit 1
fi

echo "Setup complete! Use './run.sh' to launch the app."
