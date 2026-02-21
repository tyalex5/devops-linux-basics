#!/bin/bash
# --------------------------------------------------------
# file_watch.sh
# Purpose:
#   File integrity checker for a target directory.
#
# How it works:
#   1) Builds a SHA256 baseline (first run or when requested)
#   2) Builds a current snapshot on each run
#   3) Compares baseline vs current and logs differences
# --------------------------------------------------------

# Directory to monitor
TARGET_DIR="$HOME/devops/scripts"

# Where we store integrity snapshots/logs
WORKDIR="$HOME/devops/integrity"
BASELINE_FILE="$WORKDIR/baseline.txt"
CURRENT_FILE="$WORKDIR/current.txt"
LOG_FILE="$WORKDIR/integrity_report.log"

# Ensure workdir exists
mkdir -p "$WORKDIR"

# Function: generate a snapshot of hashes for all files in target dir
generate_snapshot() {
  # find all files, sort them, hash them
  find "$TARGET_DIR" -type f -print0 \
    | sort -z \
    | xargs -0 sha256sum
}

# If baseline doesn't exist, create it automatically
if [ ! -f "$BASELINE_FILE" ]; then
  echo "$(date): Baseline not found. Creating baseline..." | tee -a "$LOG_FILE"
  generate_snapshot > "$BASELINE_FILE"
  echo "$(date): Baseline created at $BASELINE_FILE" | tee -a "$LOG_FILE"
  exit 0
fi

# Create current snapshot
generate_snapshot > "$CURRENT_FILE"

# Compare baseline vs current
DIFF_OUTPUT=$(diff -u "$BASELINE_FILE" "$CURRENT_FILE")

if [ -n "$DIFF_OUTPUT" ]; then
  # Changes detected
  echo "========================================" >> "$LOG_FILE"
  echo "$(date): CHANGES DETECTED in $TARGET_DIR" >> "$LOG_FILE"
  echo "$DIFF_OUTPUT" >> "$LOG_FILE"
  echo "$(date): See $LOG_FILE for details."
else
  # No changes
  echo "$(date): No changes detected in $TARGET_DIR" >> "$LOG_FILE"
fi
