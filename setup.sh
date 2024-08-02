#!/bin/bash

# Define log file
LOGFILE="setup.log"

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOGFILE"
}

# Check for Python installation
if ! command -v python &> /dev/null
then
    log "Python is not installed. Please install Python and try again."
    exit 1
fi

# Check for pip installation
if ! command -v pip &> /dev/null
then
    log "pip is not installed. Please install pip and try again."
    exit 1
fi

# Create a virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    log "Creating a virtual environment..."
    python -m venv venv
    if [ $? -ne 0 ]; then
        log "Failed to create a virtual environment."
        exit 1
    fi
else
    log "Virtual environment already exists. Skipping creation."
fi

# Activate the virtual environment
log "Activating the virtual environment..."
source venv/bin/activate

# Install dependencies
log "Installing dependencies from requirements.txt..."
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    log "Failed to install dependencies."
    deactivate
    exit 1
fi

# Run the Python script
log "Running the Python script..."
python agent.py
if [ $? -ne 0 ]; then
    log "Python script execution failed."
    deactivate
    exit 1
fi

log "Setup complete. To run the script again, use: source venv/bin/activate && python agent.py"
deactivate
