# Discord Embed Fixer Bot

A Discord bot that automatically fixes visual embeds for social media links by replacing URLs with embed-friendly alternatives.

## Features

- **Twitter/X Links**: Converts `twitter.com` and `x.com` URLs to `vxtwitter.com` for better embeds
- **Instagram Reels**: Converts `instagram.com` reel URLs to `instagramez.com` for better embeds
- **Guild-Specific Behavior**:
  - **Rush Site C**: Deletes Twitter/X links and DMs users
  - **Squad Footie Pajamas**: Redirects embeds to #brainrot channel
  - **Default**: Posts fixed embed in the same channel

## Quick Start

1. **Install dependencies**:
   ```bash
   uv sync
   ```

2. **Create environment file**:
   ```bash
   echo "discord=your-discord-bot-token" > .env
   ```

3. **Install as systemd service** (recommended):
   ```bash
   ./setup-service.sh
   ```

4. **Start the bot**:
   ```bash
   ./manage-bot.sh start
   ```

## Management Commands

Use the `manage-bot.sh` script for easy bot management:

```bash
./manage-bot.sh start      # Start the bot
./manage-bot.sh stop       # Stop the bot
./manage-bot.sh restart    # Restart the bot
./manage-bot.sh status     # Check status
./manage-bot.sh logs       # View live logs
./manage-bot.sh update     # Update code and restart
./manage-bot.sh install    # Install systemd service
```

## Production Deployment

The bot runs as a systemd service with the following benefits:

- ✅ **Auto-restart** on crashes
- ✅ **Boot persistence** - starts automatically on system boot
- ✅ **Proper logging** via systemd journal
- ✅ **Security** - runs with limited privileges
- ✅ **Easy management** via systemctl commands

## Logging

The bot uses two logging mechanisms:

1. **System logs**: View with `sudo journalctl -u embed-fixer -f`
2. **Activity log**: Written to `embed.log` file for embed activity tracking

## Manual Run (Development)

For testing/development, you can run manually:

```bash
uv run --env-file=.env main.py
```

## Requirements

- Python 3.11+
- uv package manager
- Discord bot token
- Linux system with systemd (for production)
