#!/bin/bash
# Log generator for incident simulation

LOG_DIR="$HOME/incident-lab/logs"
mkdir -p "$LOG_DIR"

# Generate application logs with incidents
cat > "$LOG_DIR/application.log" << 'EOF'
2024-01-15 08:00:01 INFO Application started successfully
2024-01-15 08:15:23 INFO User login: user123
2024-01-15 08:30:45 WARNING High memory usage detected: 85%
2024-01-15 08:45:12 INFO Processing request ID: 1001
2024-01-15 09:00:00 ERROR Database connection timeout after 30s
2024-01-15 09:00:15 ERROR Failed to process request ID: 1002
2024-01-15 09:00:30 ERROR Database connection timeout after 30s
2024-01-15 09:15:00 CRITICAL Service unavailable - database unreachable
2024-01-15 09:30:00 INFO Database connection restored
2024-01-15 09:45:22 WARNING Response time degraded: 5.2s (threshold: 2s)
2024-01-15 10:00:01 WARNING Response time degraded: 6.8s (threshold: 2s)
2024-01-15 10:15:33 ERROR Out of memory exception in module: DataProcessor
2024-01-15 10:30:00 CRITICAL Application crashed - insufficient memory
2024-01-15 10:45:00 INFO Application restarted by watchdog
2024-01-15 11:00:12 INFO Normal operations resumed
2024-01-15 11:30:45 WARNING Disk usage at 92%
2024-01-15 12:00:00 INFO Scheduled backup completed
EOF

# Generate web server logs
cat > "$LOG_DIR/webserver.log" << 'EOF'
2024-01-15 08:00:05 200 GET /index.html 0.05s
2024-01-15 08:15:10 200 GET /api/users 0.12s
2024-01-15 08:30:22 200 POST /api/login 0.08s
2024-01-15 08:45:33 500 GET /api/data 15.2s
2024-01-15 09:00:01 503 GET /api/data 30.0s
2024-01-15 09:00:10 503 POST /api/submit 30.0s
2024-01-15 09:00:25 503 GET /health 30.0s
2024-01-15 09:15:00 503 GET /api/status 30.0s
2024-01-15 09:30:15 200 GET /health 0.05s
2024-01-15 09:45:30 200 GET /api/data 4.5s
2024-01-15 10:00:05 200 GET /api/users 5.8s
2024-01-15 10:15:20 500 POST /api/process 8.2s
2024-01-15 10:30:00 503 GET /api/data 0.0s
2024-01-15 10:45:30 200 GET /health 0.06s
2024-01-15 11:00:00 200 GET /api/data 0.15s
EOF

# Generate system metrics log
cat > "$LOG_DIR/metrics.log" << 'EOF'
2024-01-15 08:00:00 CPU:45% MEM:60% DISK:75% NET:120Mbps
2024-01-15 08:30:00 CPU:52% MEM:68% DISK:75% NET:145Mbps
2024-01-15 09:00:00 CPU:88% MEM:85% DISK:76% NET:95Mbps
2024-01-15 09:30:00 CPU:55% MEM:72% DISK:76% NET:130Mbps
2024-01-15 10:00:00 CPU:78% MEM:92% DISK:77% NET:110Mbps
2024-01-15 10:30:00 CPU:95% MEM:98% DISK:77% NET:50Mbps
2024-01-15 11:00:00 CPU:48% MEM:65% DISK:78% NET:125Mbps
2024-01-15 11:30:00 CPU:50% MEM:70% DISK:92% NET:140Mbps
EOF

echo "Log files generated successfully in $LOG_DIR"
