#!/bin/bash

# Path to the virtual environment
VENV_PATH="/home/sun/code/venvs/embedvenv"

# Path to the repository
REPO_PATH="/home/sun/code/embed-fixer"

# Function to terminate any running instance of uv run
terminate_previous_instance() {
    if pgrep -f "uv run" > /dev/null; then
        echo "Terminating previous instance of 'uv run'"
        pkill -f "uv run"
    fi
}

# Main loop to ensure the bot runs continuously
run_bot() {
    while true; do
        # Get the current date
        current_date=$(date +%Y-%m-%d)
        
        # Clone or update the repository
        if [ ! -d "$REPO_PATH" ]; then
            git clone https://github.com/svadivazhagu/embed-fixer.git "$REPO_PATH"
        fi

        cd "$REPO_PATH" || exit
        git reset --hard
        git pull origin main
        
        # Terminate any previous instance
        terminate_previous_instance

        # Sync dependencies and start the bot
        echo "Starting bot for date: $current_date"
        uv sync
        uv run --env-file=.env main.py
        
        # Wait until the next day
        while [ "$(date +%Y-%m-%d)" == "$current_date" ]; do
            sleep 300  # Check every 5 minutes
        done
        
        # Kill the current bot instance
        echo "New day detected, restarting process..."
        kill $bot_pid

        # Deactivate the virtual environment
        deactivate

        cd ..
    done
}

# Start the bot
run_bot
