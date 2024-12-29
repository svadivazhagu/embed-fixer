# File 3: install.sh
# Location: systemd/install.sh
# Purpose: Script that installs everything
#!/bin/bash
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Create service user
id -u discordbot &>/dev/null || useradd -r -s /bin/false discordbot

# Create working directory
mkdir -p /opt/discord-bot
chown discordbot:discordbot /opt/discord-bot

# Create and install the runner script
cat > /usr/local/bin/discord-bot-runner.sh << 'EOF'
#!/bin/bash

# Load environment variables
set -a
source /etc/discord-bot.env
set +a

# Run the bot
cd /opt/discord-bot

if [ ! -d "embed-fixer" ]; then
    git clone https://github.com/svadivazhagu/embed-fixer.git
    cd embed-fixer
else
    cd embed-fixer
    git pull origin main
fi

exec python3 main.py
EOF

# Make runner script executable
chmod +x /usr/local/bin/discord-bot-runner.sh

# Copy and setup environment file if it doesn't exist
if [ ! -f /etc/discord-bot.env ]; then
    cp systemd/discord-bot.env.example /etc/discord-bot.env
    chmod 600 /etc/discord-bot.env
    echo "Created /etc/discord-bot.env - please edit it with your API key"
fi

# Install the service file
cp systemd/discord-bot.service /etc/systemd/system/

# Setup logging
touch /var/log/discord-bot.log /var/log/discord-bot.error.log
chown discordbot:discordbot /var/log/discord-bot.log /var/log/discord-bot.error.log

# Enable the service
systemctl daemon-reload
systemctl enable discord-bot.service

echo "Installation complete!"
echo "1. Edit /etc/discord-bot.env with your Discord API key"
echo "2. Start the service with: systemctl start discord-bot.service"
echo "3. Check status with: systemctl status discord-bot.service"