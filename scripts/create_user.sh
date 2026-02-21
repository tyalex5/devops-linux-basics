#!/bin/bash
# -------------------------------------------------------
# create_user.sh
# Purpose:
#   Provision a new Linux user and create a projects folder.
#   Logs actions to a file for auditing.
#
# What it does:
#   1) Prompts for a username
#   2) Checks if the user already exists
#   3) Creates the user (sudo adduser)
#   4) Creates /home/<user>/projects
#   5) Sets permissions and ownership
#   6) Logs all actions
# -------------------------------------------------------

# Log file path (stored in your DevOps workspace)
USER_CREATION_LOG="$HOME/devops/user_creation.log"

# Prompt for username (read -p prints prompt + reads input)
read -p "Enter the username to create (e.g., appuser): " username

# Basic validation: ensure input isn't empty
if [ -z "$username" ]; then
  echo "ERROR: Username cannot be empty."
  exit 1
fi

# Check if user already exists
# id returns exit code 0 if user exists, non-zero if not
if id "$username" >/dev/null 2>&1; then
  echo "$(date): User '$username' already exists. No action taken." >> "$USER_CREATION_LOG"
  echo "User '$username' already exists."
  exit 0
fi

# Create the user (requires sudo)
echo "$(date): Creating user '$username'..." >> "$USER_CREATION_LOG"
sudo adduser "$username"

# Create the projects directory (requires sudo because /home/<user> is owned by that user/root)
PROJECT_DIR="/home/$username/projects"
echo "$(date): Creating directory '$PROJECT_DIR'..." >> "$USER_CREATION_LOG"
sudo mkdir -p "$PROJECT_DIR"

# Set permissions: 755 = owner can rwx, others can rx
echo "$(date): Setting permissions 755 on '$PROJECT_DIR'..." >> "$USER_CREATION_LOG"
sudo chmod 755 "$PROJECT_DIR"

# Set ownership so the new user owns their own projects folder
echo "$(date): Setting ownership to '$username:$username' on '$PROJECT_DIR'..." >> "$USER_CREATION_LOG"
sudo chown -R "$username:$username" "$PROJECT_DIR"

# Completion message + log
echo "$(date): User '$username' provisioned successfully." >> "$USER_CREATION_LOG"
echo "Done! Created user '$username' and '$PROJECT_DIR'."
echo "Log written to: $USER_CREATION_LOG"

