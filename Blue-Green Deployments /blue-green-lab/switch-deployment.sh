#!/bin/bash

# Blue-Green Deployment Switcher
# Usage: ./switch-deployment.sh [blue|green]

ENVIRONMENT=$1

if [ "$ENVIRONMENT" != "blue" ] && [ "$ENVIRONMENT" != "green" ]; then
    echo "Usage: $0 [blue|green]"
    exit 1
fi

# TODO: Set the correct port based on environment
if [ "$ENVIRONMENT" == "blue" ]; then
    PORT=____  # Blue port
    VERSION="1.0"
else
    PORT=____  # Green port
    VERSION="2.0"
fi

echo "Switching to $ENVIRONMENT environment (v$VERSION)..."

# Generate new Nginx configuration
cat > /tmp/blue-green-nginx.conf << NGINX_EOF
upstream backend {
    server localhost:$PORT;
}

server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
NGINX_EOF

# Apply configuration
sudo cp /tmp/blue-green-nginx.conf /etc/nginx/sites-available/blue-green

# Test configuration
if sudo nginx -t; then
    sudo systemctl reload nginx
    echo "Successfully switched to $ENVIRONMENT environment!"
    echo "Verifying deployment..."
    sleep 2
    curl -s http://localhost | grep -o "Version [0-9.]*"
else
    echo "Configuration test failed. Rolling back..."
    exit 1
fi
