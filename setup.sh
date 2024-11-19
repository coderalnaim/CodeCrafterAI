#!/bin/bash

echo "Setting up your environment..."

# Step 1: Dynamically Set Working Directory
BASE_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$BASE_DIR" || { echo "Error: Failed to change directory to $BASE_DIR. Exiting."; exit 1; }

echo "Using working directory: \"$BASE_DIR\""

# Step 2: Check Python Installation
if command -v python3 &>/dev/null; then
    PYTHON_EXECUTABLE="python3"
elif command -v python &>/dev/null; then
    PYTHON_EXECUTABLE="python"
else
    echo "Error: Python is not installed. Please install Python 3.8 or later."
    exit 1
fi

echo "Using Python executable: $PYTHON_EXECUTABLE"

# Step 3: Create a Virtual Environment
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    $PYTHON_EXECUTABLE -m venv venv || { echo "Error: Failed to create virtual environment. Exiting."; exit 1; }
else
    echo "Virtual environment already exists. Skipping creation."
fi

# Step 4: Activate the Virtual Environment
if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate || { echo "Error: Failed to activate virtual environment. Exiting."; exit 1; }
elif [ -f "venv/Scripts/activate" ]; then # Windows WSL Compatibility
    source venv/Scripts/activate || { echo "Error: Failed to activate virtual environment (Windows). Exiting."; exit 1; }
else
    echo "Error: Virtual environment activation script not found. Exiting."
    exit 1
fi

# Debugging: Show Active Python Path
echo "Active Python executable: $(which python)"

# Step 5: Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip || { echo "Error: Failed to upgrade pip. Exiting."; deactivate; exit 1; }

# Step 6: Install Requirements

echo "Installing dependencies from requirements.txt..."
pip install -r "requirements.txt" || { echo "Error: Failed to install dependencies. Exiting."; deactivate; exit 1; }


echo "Setup complete! Use './run.sh' to launch the app."

# Step 7: Deactivate Virtual Environment After Setup
deactivate
