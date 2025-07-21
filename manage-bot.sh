#\!/bin/bash

# Management script for embed-fixer bot

SERVICE_NAME="embed-fixer"

case "${1:-}" in
    start)
        echo "🚀 Starting ${SERVICE_NAME}..."
        sudo systemctl start "$SERVICE_NAME"
        ;;
    stop)
        echo "🛑 Stopping ${SERVICE_NAME}..."
        sudo systemctl stop "$SERVICE_NAME"
        ;;
    restart)
        echo "🔄 Restarting ${SERVICE_NAME}..."
        sudo systemctl restart "$SERVICE_NAME"
        ;;
    status)
        sudo systemctl status "$SERVICE_NAME"
        ;;
    logs)
        echo "📋 Showing logs for ${SERVICE_NAME} (Ctrl+C to exit)..."
        sudo journalctl -u "$SERVICE_NAME" -f
        ;;
    update)
        echo "📥 Updating ${SERVICE_NAME}..."
        git pull origin main
        uv sync
        sudo systemctl restart "$SERVICE_NAME"
        echo "✅ Update complete\!"
        ;;
    install)
        echo "🛠️ Installing ${SERVICE_NAME} service..."
        ./setup-service.sh
        ;;
    *)
        echo "Usage: $0 {start < /dev/null | stop|restart|status|logs|update|install}"
        echo
        echo "Commands:"
        echo "  start    - Start the bot service"
        echo "  stop     - Stop the bot service"
        echo "  restart  - Restart the bot service"
        echo "  status   - Show service status"
        echo "  logs     - Show live logs"
        echo "  update   - Pull latest code and restart"
        echo "  install  - Install systemd service"
        exit 1
        ;;
esac
