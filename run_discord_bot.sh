#!/bin/bash

# Path to the virtual environment
VENV_PATH="/home/sun/code/venvs/embedvenv"

# Path to the repository
REPO_PATH="/home/sun/code/embed-fixer"

# Function to check and prompt for Discord API key
check_discord_key() {
    if [ -z "${discord}" ]; then
        echo "Discord API key not found in environment variables"
        read -p "Please enter your Discord API key: " discord_key

        # Save the key in /etc/environment for persistence
        if ! grep -q '^discord=' /etc/environment; then
            echo "Saving Discord API key to /etc/environment"
            echo "discord=$discord_key" | sudo tee -a /etc/environment > /dev/null
        else
            sudo sed -i "s/^discord=.*/discord=$discord_key/" /etc/environment
        fi

        # Reload system-wide environment variables
        export discord="$discord_key"
        source /etc/environment
    fi
}

# Function to terminate any running instance of main.py
terminate_previous_instance() {
    if pgrep -f "python3 main.py" > /dev/null; then
        echo "Terminating previous instance of main.py"
        pkill -f "python3 main.py"
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
        
        # Check for Discord key
        check_discord_key

        # Activate the virtual environment
        source "$VENV_PATH/bin/activate"

        # Terminate any previous instance
        terminate_previous_instance

        # Start the bot
        echo "Starting bot for date: $current_date"
        discord=$discord python3 main.py &
        bot_pid=$!
        
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
