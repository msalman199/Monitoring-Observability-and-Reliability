#!/bin/bash

LOG_FILE="$HOME/deployment-lab/rollback.log"

log_event() {
    local event_type=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # TODO: Append log entry with timestamp, event type, and message
    # Format: [TIMESTAMP] EVENT_TYPE: MESSAGE
    
    echo "[$timestamp] $event_type: $message" >> "$LOG_FILE"
}

# Usage example
log_event "ROLLBACK" "Rolled back from v2.0 to v1.0"
log_event "VERIFY" "Deployment verification successful"

# Display recent logs
echo "Recent rollback events:"
tail -n 5 "$LOG_FILE"
