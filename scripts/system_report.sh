#!/bin/bash
# -------------------------------------------------
# system_report.sh
# Purpose:
#   Generate a simple system health report including:
#   - Hostname
#   - Date
#   - Disk usage
#   - Memory usage
#   - System uptime
#
# This simulates a basic DevOps monitoring script.
# -------------------------------------------------

# Store hostname in a variable
HOSTNAME=$(hostname)

# Store current date/time
DATE=$(date)

# Capture disk usage (human readable)
DISK=$(df -h / | tail -1 | awk '{print $5}')

# Capture memory usage
MEMORY=$(free -h | awk '/Mem/ {print $3 "/" $2}')

# Capture system uptime
UPTIME=$(uptime -p)

# Define report file location. Use HOME environment variable instead of hardcoding path
REPORT_FILE="$HOME/devops/system_report.txt"

# Append separator
echo "===================================" >> $REPORT_FILE
# Write report header ( >> append to file )
echo "System Report for $HOSTNAME" >> $REPORT_FILE
echo "Generated on: $DATE" >> $REPORT_FILE
# Append separator
echo "----------------------------" >> $REPORT_FILE

# Add system stats
echo "Disk Usage: $DISK" >> $REPORT_FILE
echo "Memory Usage: $MEMORY" >> $REPORT_FILE
echo "Uptime: $UPTIME" >> $REPORT_FILE

# Simple conditional check on disk usage
# If disk usage is over 80%, print warning

DISK_PERCENT=${DISK%\%}

if [ "$DISK_PERCENT" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%" >> $REPORT_FILE
else
    echo "Disk usage is normal" >> $REPORT_FILE
fi

# Print completion message to terminal
echo "System report generated at:"
echo "$REPORT_FILE"
