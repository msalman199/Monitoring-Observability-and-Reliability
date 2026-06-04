#!/bin/bash

# Log Analysis Script
LOG_FILE="application.log"

echo "=== Log Analysis Summary ==="
echo "Log file: $LOG_FILE"
echo ""

# Count each severity level
INFO_COUNT=$(grep -c "INFO" $LOG_FILE)
WARNING_COUNT=$(grep -c "WARNING" $LOG_FILE)
ERROR_COUNT=$(grep -c "ERROR" $LOG_FILE)
TOTAL_COUNT=$(wc -l < $LOG_FILE)

echo "Total entries: $TOTAL_COUNT"
echo "INFO messages: $INFO_COUNT"
echo "WARNING messages: $WARNING_COUNT"
echo "ERROR messages: $ERROR_COUNT"
echo ""
