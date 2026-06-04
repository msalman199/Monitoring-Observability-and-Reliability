# 🔄 Rollback Procedures 

<p align="center">

![Linux](https://img.shields.io/badge/Linux-Ubuntu-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Git](https://img.shields.io/badge/Git-Version_Control-F05032?style=for-the-badge&logo=git&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-Web_Server-009639?style=for-the-badge&logo=nginx&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-Rollback_Management-blue?style=for-the-badge)
![Deployment](https://img.shields.io/badge/Deployment-Recovery-success?style=for-the-badge)

</p>

---

# 📖 Rollback Procedures

## 🎯 Overview

Rollback procedures are a critical component of deployment management. They allow teams to quickly restore a previously working version of an application when a deployment introduces bugs, outages, or unexpected behavior.

In this lab, you will build a rollback system using:

- 🔹 Git Version Control
- 🔹 Nginx Web Server
- 🔹 Backup Management
- 🔹 Deployment Automation
- 🔹 Audit Logging

---

# 📋 Prerequisites

Before starting this lab, ensure you have:

✅ Basic Linux command-line knowledge

✅ Understanding of deployment concepts

✅ Familiarity with Git version control

✅ Basic Nginx knowledge

✅ File editing skills using nano/vim

---

# 🎯 Learning Objectives

By the end of this lab, you will be able to:

✅ Implement deployment rollback strategies

✅ Simulate deployment failures

✅ Restore previous application versions

✅ Verify deployment status

✅ Maintain rollback audit logs

---

# 🛠️ Environment Setup

---

## 🔹 Step 1: Install Required Packages

Update package manager:

```bash
sudo apt update
```

Install dependencies:

```bash
sudo apt install -y git nginx curl
```

Verify installations:

```bash
git --version

nginx -v

curl --version
```

---

## 🔹 Step 2: Create Project Structure

Create directories:

```bash
mkdir -p ~/deployment-lab/{app,backups,scripts}
```

Move into lab:

```bash
cd ~/deployment-lab
```

Verify structure:

```bash
tree ~/deployment-lab
```

Expected:

```text
deployment-lab/
├── app
├── backups
└── scripts
```

---

## 🔹 Step 3: Configure Git

Set Git identity:

```bash
git config --global user.name "Lab User"
```

```bash
git config --global user.email "lab@example.com"
```

Verify:

```bash
git config --list
```

---

# 🚀 Task 1: Setup Application with Versioning

---

## 🔹 Step 1: Create Initial Application Version

Navigate:

```bash
cd ~/deployment-lab/app
```

Create application:

```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<title>App Version 1.0</title>
</head>

<body>

<h1>Application Version 1.0</h1>

<p>Status: Stable Release</p>

<p>Build: 2024-01-15</p>

</body>
</html>
EOF
```

---

## 🔹 Step 2: Initialize Git Repository

Initialize:

```bash
git init
```

Add files:

```bash
git add index.html
```

Commit:

```bash
git commit -m "Release v1.0 - Initial stable version"
```

Create tag:

```bash
git tag -a v1.0 -m "Version 1.0 - Stable"
```

Verify:

```bash
git tag
```

Expected:

```text
v1.0
```

---

## 🔹 Step 3: Create Deployment Script

Navigate:

```bash
cd ~/deployment-lab/scripts
```

Create script:

```bash
cat > deploy.sh << 'EOF'
#!/bin/bash

VERSION=$1

DEPLOY_DIR="/var/www/html"
BACKUP_DIR="$HOME/deployment-lab/backups"
APP_DIR="$HOME/deployment-lab/app"

deploy() {

    local version=$1

    echo "Deploying version: $version"

    TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    BACKUP_NAME="backup_${TIMESTAMP}"

    if [ -d "$DEPLOY_DIR" ]; then

        sudo mkdir -p "$BACKUP_DIR"

        sudo cp -r "$DEPLOY_DIR" "$BACKUP_DIR/$BACKUP_NAME"

        echo "Backup created: $BACKUP_NAME"

    fi

    cd "$APP_DIR"

    git checkout "$version"

    sudo cp -r * "$DEPLOY_DIR/"

    sudo systemctl restart nginx

    echo "Deployment completed for $version"
}

rollback() {

    echo "Initiating rollback procedure..."

    LATEST_BACKUP=$(ls -t "$BACKUP_DIR" | head -1)

    if [ -z "$LATEST_BACKUP" ]; then

        echo "Error: No backups found"

        exit 1

    fi

    echo "Rolling back to: $LATEST_BACKUP"

    sudo rm -rf "$DEPLOY_DIR"/*

    sudo cp -r "$BACKUP_DIR/$LATEST_BACKUP"/* "$DEPLOY_DIR"/

    sudo systemctl restart nginx

    echo "Rollback completed successfully"
}

verify_deployment() {

    echo "Verifying deployment..."

    if sudo systemctl is-active --quiet nginx; then

        echo "✓ Nginx is running"

    else

        echo "✗ Nginx is not running"

        return 1

    fi

    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)

    if [ "$HTTP_CODE" = "200" ]; then

        echo "✓ HTTP response: $HTTP_CODE"

    else

        echo "✗ HTTP response: $HTTP_CODE"

        return 1

    fi

    echo ""
    echo "Current deployed version:"

    curl -s http://localhost | grep -o "Version [0-9.]*"
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
EOF
```

Make executable:

```bash
chmod +x deploy.sh
```

---

## 🔹 Step 4: Configure Nginx

Start service:

```bash
sudo systemctl start nginx
```

Enable startup:

```bash
sudo systemctl enable nginx
```

Verify:

```bash
sudo systemctl status nginx
```

Expected:

```text
active (running)
```

---

## 🔹 Step 5: Deploy Initial Version

Deploy:

```bash
cd ~/deployment-lab/scripts

./deploy.sh deploy v1.0
```

Verify:

```bash
curl http://localhost
```

Expected:

```text
Application Version 1.0
```

---

# 🚨 Task 2: Simulate Failure and Execute Rollback

---

## 🔹 Step 1: Create Broken Version

Navigate:

```bash
cd ~/deployment-lab/app
```

Replace file:

```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<title>App Version 2.0</title>
</head>

<body>

<h1>Application Version 2.0</h1>

<p>Status: BROKEN - Database connection failed</p>

<p>Build: 2024-01-20</p>

<script>
console.error("Critical error: Cannot connect to database");
</script>

</body>
</html>
EOF
```

Commit:

```bash
git add index.html
```

```bash
git commit -m "Release v2.0 - Contains critical bug"
```

Tag:

```bash
git tag -a v2.0 -m "Version 2.0 - Broken release"
```

Verify:

```bash
git tag
```

Expected:

```text
v1.0
v2.0
```

---

## 🔹 Step 2: Deploy Broken Version

Deploy:

```bash
cd ~/deployment-lab/scripts

./deploy.sh deploy v2.0
```

Verify:

```bash
curl http://localhost
```

Expected:

```text
Application Version 2.0
BROKEN - Database connection failed
```

---

## 🔹 Step 3: Execute Rollback

Run:

```bash
./deploy.sh rollback
```

Expected:

```text
Rollback completed successfully
```

---

## 🔹 Step 4: Verify Rollback

Verify deployment:

```bash
./deploy.sh verify
```

Expected:

```text
✓ Nginx is running
✓ HTTP response: 200
Version 1.0
```

---

## 🔹 Step 5: Verify Application

Check:

```bash
curl http://localhost
```

Expected:

```text
Application Version 1.0
```

Stable version restored successfully.

---

## 🔹 Step 6: Create Rollback Logging System

Create script:

```bash
cat > ~/deployment-lab/scripts/log_rollback.sh << 'EOF'
#!/bin/bash

LOG_FILE="$HOME/deployment-lab/rollback.log"

log_event() {

    local event_type=$1

    local message=$2

    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$timestamp] $event_type: $message" >> "$LOG_FILE"
}

log_event "ROLLBACK" "Rolled back from v2.0 to v1.0"

log_event "VERIFY" "Deployment verification successful"

echo "Recent rollback events:"

tail -n 5 "$LOG_FILE"
EOF
```

Make executable:

```bash
chmod +x log_rollback.sh
```

Run:

```bash
./log_rollback.sh
```

---

# 📊 Verification

---

## Verify Backups

```bash
ls -lh ~/deployment-lab/backups/
```

Expected:

```text
backup_YYYYMMDD_HHMMSS
```

---

## Verify Git Tags

```bash
cd ~/deployment-lab/app

git tag
```

Expected:

```text
v1.0
v2.0
```

---

## Verify Deployment Script

```bash
cd ~/deployment-lab/scripts

./deploy.sh verify
```

Expected:

```text
✓ Nginx is running
✓ HTTP response: 200
```

---

## Verify HTTP Response

```bash
curl -I http://localhost
```

Expected:

```text
HTTP/1.1 200 OK
```

---

## Verify Rollback Logs

```bash
cat ~/deployment-lab/rollback.log
```

Expected:

```text
[2026-06-03 10:15:00] ROLLBACK: Rolled back from v2.0 to v1.0
```

---

# 🔄 Complete Deployment Cycle Test

Deploy broken version:

```bash
./deploy.sh deploy v2.0
```

Verify:

```bash
curl http://localhost | grep "Version 2.0"
```

Rollback:

```bash
./deploy.sh rollback
```

Verify:

```bash
curl http://localhost | grep "Version 1.0"
```

Expected:

```text
Application Version 1.0
```

---

# ✅ Verification Checklist

- [x] Git Repository Initialized
- [x] Version Tags Created
- [x] Deployment Script Functional
- [x] Backup Creation Working
- [x] Broken Deployment Simulated
- [x] Rollback Procedure Executed
- [x] Verification Checks Passed
- [x] Audit Logs Generated
- [x] Stable Version Restored

---

# 🛠️ Troubleshooting

---

## ❌ Nginx Fails to Start

Validate configuration:

```bash
sudo nginx -t
```

Check port usage:

```bash
sudo netstat -tlnp | grep :80
```

---

## ❌ Permission Denied

Make scripts executable:

```bash
chmod +x *.sh
```

Verify sudo access:

```bash
sudo -l
```

---

## ❌ Backup Directory Missing

Create manually:

```bash
mkdir -p ~/deployment-lab/backups
```

Verify:

```bash
ls ~/deployment-lab
```

---

## ❌ Git Checkout Fails

Check tags:

```bash
git tag -l
```

Verify repository:

```bash
git status
```

---

# 🎓 Conclusion

Congratulations! You have successfully implemented a deployment rollback system.

You learned how to:

✅ Manage application versions with Git

✅ Create automated deployment backups

✅ Simulate deployment failures

✅ Restore stable application releases

✅ Verify deployment health

✅ Maintain rollback audit logs

---

# 💡 Key Takeaways

### 🔹 Always Create Backups

Every deployment should have a recovery point.

### 🔹 Use Git Tags

Tags provide clear version references.

### 🔹 Verify After Deployment

Health checks detect failures early.

### 🔹 Automate Rollbacks

Faster recovery means less downtime.

### 🔹 Maintain Audit Logs

Logs improve troubleshooting and compliance.

---

# 🌍 Real-World Applications

Rollback procedures are essential for:

✅ Production Deployments

✅ CI/CD Pipelines

✅ Kubernetes Releases

✅ Cloud Infrastructure Updates

✅ Enterprise Change Management

✅ Disaster Recovery Plans

---

# 🚀 Next Steps

### 🔹 Database Rollbacks

Learn safe schema rollback procedures.

### 🔹 Automated Health Checks

Trigger rollbacks automatically on failures.

### 🔹 CI/CD Integration

Integrate rollback logic into:

- GitHub Actions
- GitLab CI/CD
- Jenkins

### 🔹 Kubernetes Rollbacks

Study:

```bash
kubectl rollout undo deployment/app
```

### 🔹 Deployment Monitoring

Explore:

- Prometheus
- Grafana
- ELK Stack
- Loki

---

# 🏆 Lab Completed Successfully

```text
✔ Git Repository Created
✔ Version Tags Added
✔ Application Deployed
✔ Backup Created
✔ Failure Simulated
✔ Rollback Executed
✔ Verification Passed
✔ Logs Generated
✔ Stable Version Restored
```

🎉 Congratulations! You now have practical experience implementing rollback procedures, one of the most important safeguards in modern DevOps and production deployment workflows.
