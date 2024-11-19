#!/usr/bin/env bash

echo "Setting up your environment for Unix-like systems..."

# Step 1: Set Working Directory
BASE_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$BASE_DIR" || { echo "Error: Failed to change directory. Exiting."; exit 1; }

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

# Step 3: Create Virtual Environment
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    $PYTHON_EXECUTABLE -m venv venv || { echo "Error: Failed to create virtual environment."; exit 1; }
else
    echo "Virtual environment already exists. Skipping creation."
fi

# Step 4: Activate the Virtual Environment
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    ACTIVATE_SCRIPT="venv/Scripts/activate"
else
    ACTIVATE_SCRIPT="venv/bin/activate"
fi

if [ -f "$ACTIVATE_SCRIPT" ]; then
    source "$ACTIVATE_SCRIPT"
else
    echo "Error: Could not find the activation script."
    exit 1
fi

echo "Active Python executable: $(which python)"

# Step 5: Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip || { echo "Error: Failed to upgrade pip."; deactivate; exit 1; }

# Step 6: Install Requirements
if [ -f "$BASE_DIR/requirements.txt" ]; then
    echo "Installing dependencies from requirements.txt..."
    pip install -r "$BASE_DIR/requirements.txt" || { echo "Error: Failed to install dependencies."; deactivate; exit 1; }
else
    echo "Error: requirements.txt not found in \"$BASE_DIR\". Please ensure it exists."
    deactivate
    exit 1
fi

echo "Setup complete! Use './run.sh' to launch the app."

# Step 7: Deactivate Virtual Environment After Setup
deactivate
