#\!/bin/bash

# Setup script for embed-fixer systemd service

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_NAME="embed-fixer"
SERVICE_FILE="${SERVICE_NAME}.service"

echo "🚀 Setting up ${SERVICE_NAME} systemd service..."

# Check if .env file exists
if [[ \! -f "${SCRIPT_DIR}/.env" ]]; then
    echo "❌ Error: .env file not found\!"
    echo "Create .env file with: echo \"discord=your-discord-bot-token\" > .env"
    exit 1
fi

# Check if uv is installed
if \! command -v uv &> /dev/null; then
    echo "❌ Error: uv not found in PATH"
    echo "Install uv with: curl -LsSf https://astral.sh/uv/install.sh  < /dev/null |  sh"
    exit 1
fi

# Sync dependencies
echo "📦 Syncing dependencies..."
uv sync

# Copy service file to systemd directory
echo "📋 Installing systemd service..."
sudo cp "${SERVICE_FILE}" "/etc/systemd/system/"

# Reload systemd and enable service
echo "🔄 Enabling systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable "${SERVICE_NAME}"

echo "✅ Service setup complete\!"
echo
echo "Usage commands:"
echo "  Start:   sudo systemctl start ${SERVICE_NAME}"
echo "  Stop:    sudo systemctl stop ${SERVICE_NAME}"
echo "  Status:  sudo systemctl status ${SERVICE_NAME}"
echo "  Logs:    sudo journalctl -u ${SERVICE_NAME} -f"
echo "  Restart: sudo systemctl restart ${SERVICE_NAME}"
