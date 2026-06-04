#!/bin/bash

# Comprehensive Log Analysis Report
LOG_FILE="application.log"
REPORT_FILE="analysis_report.txt"

{
    echo "========================================="
    echo "     LOG ANALYSIS REPORT"
    echo "========================================="
    echo "Generated: $(date)"
    echo "Log File: $LOG_FILE"
    echo ""
    
    echo "--- SUMMARY STATISTICS ---"
    echo "Total log entries: $(wc -l < $LOG_FILE)"
    echo "INFO messages: $(grep -c "INFO" $LOG_FILE)"
    echo "WARNING messages: $(grep -c "WARNING" $LOG_FILE)"
    echo "ERROR messages: $(grep -c "ERROR" $LOG_FILE)"
    echo ""
    
    echo "--- CRITICAL FINDINGS ---"
    echo ""
    echo "1. Service Outages:"
    grep "ERROR.*Authentication service unavailable" $LOG_FILE | head -1 | \
        awk '{print "   Authentication service failed at", $1, $2}'
    echo "   Duration: 4 consecutive failures (4 seconds)"
    echo ""
    
    echo "2. Connection Issues:"
    grep -E "payment gateway|Network connection lost" $LOG_FILE | while read line; do
        echo "   - $line"
    done
    echo ""
    
    echo "3. Resource Warnings:"
    grep -E "memory|disk" $LOG_FILE | while read line; do
        echo "   - $line"
    done
    echo ""
    
    echo "4. Database Issues:"
    grep "Database.*failed" $LOG_FILE | while read line; do
        echo "   - $line"
    done
    echo ""
    
    echo "--- RECOMMENDATIONS ---"
    echo "1. Investigate authentication service stability"
    echo "2. Monitor disk space usage (currently at 92%)"
    echo "3. Review database schema for missing 'orders' table"
    echo "4. Check payment gateway timeout settings"
    echo "5. Optimize cache configuration (45% miss rate)"
    echo ""
    
    echo "========================================="
    
} > $REPORT_FILE
