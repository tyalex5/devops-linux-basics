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

# Environment (development / staging / production)
ENVIRONMENT=${APP_ENV:-unknown}

# Store hostname in a variable
HOSTNAME=$(hostname)

# Store current date/time
DATE=$(date)

# Capture disk usage (human readable)
# Disk usage percentage
DISK=$(df -h / | awk 'NR==2 {print $5}')
DISK_PERCENT=${DISK%\%}

# Capture memory usage
MEMORY=$(free -h | awk '/Mem/ {print $3 "/" $2}')

# CPU usage
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $80}')

# Capture system uptime
UPTIME=$(uptime -p)

# Define report file location. Use HOME environment variable instead of hardcoding path
REPORT_FILE="$HOME/devops/system_report.txt"

# Append separator
echo "===================================" >> $REPORT_FILE

# Write report header ( >> append to file )
echo "System Report for $HOSTNAME" >> $REPORT_FILE
echo "Environment: $ENVIRONMENT" >> $REPORT_FILE
echo "Generated on: $DATE" >> $REPORT_FILE

# Append separator
echo "----------------------------" >> $REPORT_FILE

# Add system stats
echo "Disk Usage: $DISK" >> $REPORT_FILE
echo "Memory Usage: $MEMORY" >> $REPORT_FILE
echo "Uptime: $UPTIME" >> $REPORT_FILE
echo "CPU Usage: ${CPU}%" >> $REPORT_FILE


# Top 5 memory-consuming processes
echo "Top Memory Processes:" >> "$REPORT_FILE"
ps aux --sort=-%mem | head -6 >> "$REPORT_FILE"


# Simple conditional check on disk usage if disk usage is over 80%, print warning

if [ "$DISK_PERCENT" -gt 80 ]; then
    echo "WARNING: Disk usage above 80%" >> "$REPORT_FILE"
    echo -e "\e[31mWARNING: Disk usage above 80%\e[0m"
else
    echo "Disk usage normal" >> "$REPORT_FILE"
    echo -e "\e[32mDisk usage normal\e[0m"
fi

# Print completion message to terminal
echo "System report generated at:"
echo "$REPORT_FILE"
