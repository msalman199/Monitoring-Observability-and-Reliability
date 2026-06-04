#!/bin/bash

# Deployment script with rollback support
# TODO: Complete the deployment logic

VERSION=$1
DEPLOY_DIR="/var/www/html"
BACKUP_DIR="$HOME/deployment-lab/backups"
APP_DIR="$HOME/deployment-lab/app"

deploy() {
    local version=$1
    echo "Deploying version: $version"
    
    # TODO: Implement backup of current deployment
    # Hint: Use timestamp for backup naming
    
    # TODO: Implement deployment from Git tag
    # Hint: Use git checkout to switch versions
    
    # TODO: Copy files to web server directory
    
    # TODO: Restart web server
}

# TODO: Implement function signature
rollback() {
    # TODO: List available backups
    # TODO: Restore from most recent backup
    # TODO: Restart web server
    pass
}

verify_deployment() {
    # TODO: Check if web server is running
    # TODO: Test HTTP response
    # TODO: Display current version
    pass
}

case "$1" in
    deploy)
        deploy "$2"
        ;;
    rollback)
        rollback
        ;;
    verify)
        verify_deployment
        ;;
    *)
        echo "Usage: $0 {deploy|rollback|verify} [version]"
        exit 1
esac
# Add after the deploy() function declaration:

    # Create backup with timestamp
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_NAME="backup_${TIMESTAMP}"
    
    if [ -d "$DEPLOY_DIR" ]; then
        sudo mkdir -p "$BACKUP_DIR"
        sudo cp -r "$DEPLOY_DIR" "$BACKUP_DIR/$BACKUP_NAME"
        echo "Backup created: $BACKUP_NAME"
    fi
    
    # Checkout specified version
    cd "$APP_DIR"
    git checkout "$version"
    
    # Deploy to web server
    sudo cp -r * "$DEPLOY_DIR/"
    sudo systemctl restart nginx
    
    echo "Deployment completed for $version"
    rollback() {
    echo "Initiating rollback procedure..."
    
    # Find most recent backup
    LATEST_BACKUP=$(ls -t "$BACKUP_DIR" | head -1)
    
    if [ -z "$LATEST_BACKUP" ]; then
        echo "Error: No backups found"
        exit 1
    fi
    
    echo "Rolling back to: $LATEST_BACKUP"
    
    # TODO: Remove current deployment
    # Hint: sudo rm -rf "$DEPLOY_DIR"/*
    
    # TODO: Restore from backup
    # Hint: sudo cp -r "$BACKUP_DIR/$LATEST_BACKUP"/* "$DEPLOY_DIR"/
    
    # TODO: Restart nginx
    # Hint: sudo systemctl restart nginx
    
    echo "Rollback completed successfully"
}
