#!/bin/bash

# Anomaly Detection Script
LOG_FILE="application.log"

echo "=== Anomaly Detection Report ==="
echo ""

# Find repeated errors (appearing 3+ times)
echo "1. Repeated Error Messages:"
grep "ERROR" $LOG_FILE | sort | uniq -c | awk '$1 >= 3 {print "   Found", $1, "occurrences:", substr($0, index($0,$4))}'
echo ""

# Find critical keywords
echo "2. Critical Issues Detected:"
grep -i -E "failed|unavailable|lost|timeout" $LOG_FILE | while read line; do
    echo "   - $line"
done
echo ""

# Find high resource usage warnings
echo "3. Resource Warnings:"
grep -E "memory|disk|cache" $LOG_FILE | while read line; do
    echo "   - $line"
done
echo ""
