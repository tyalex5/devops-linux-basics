#!/bin/bash

# -----------------------------------------
# Mini Project 1 - Log Monitor
# Purpose:
#   Count ERROR entries in app.log
#   Generate alert if threshold exceeded

HOSTNAME=$(hostname)

DATE=$(date)

ALERT_REPORT="$HOME/devops/alert_log.txt"

# Cron execution log
CRON_LOG="$HOME/devops/cron_monitor.log"

# Count ERROR lines in app.log
# grep finds ERROR
# wc -l counts matching lines
ERROR_COUNT=$(grep ERROR app.log | wc -l)

echo "Run at: $(date '+%Y-%m-%d %H:%M:%S')" >> "$ALERT_REPORT"
echo "System Report for $HOSTNAME" >> "$ALERT_REPORT"
echo "==========================================" >> "$ALERT_REPORT"
echo "Generated on: $DATE" >> "$ALERT_REPORT"
echo "Total ERROR count: $ERROR_COUNT" >> "$ALERT_REPORT"

if [ "$ERROR_COUNT" -gt 3 ]; then
    echo "WARNING: $ERROR_COUNT error have occurred" >> "$ALERT_REPORT"
else
    echo "System healthy - no alert triggered" >> "$ALERT_REPORT"
fi


# Log execution time for cron debugging
echo "Log monitor executed at $(date)" >> "$CRON_LOG"
