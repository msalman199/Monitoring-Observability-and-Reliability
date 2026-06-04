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
