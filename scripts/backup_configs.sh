#!/bin/bash

# --- Define Backup Location ---
# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$0")

# Go one level up from the script's directory to find the base of your dotfiles repo
DOTFILES_REPO_BASE=$(dirname "$SCRIPT_DIR")

# Define the backup directory within the repo base
BACKUP_BASE_DIR="${DOTFILES_REPO_BASE}/dotfiles_backups"

# Create a timestamp for the backup directory
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="${BACKUP_BASE_DIR}/${TIMESTAMP}"

# --- Configurations to Backup ---
CONFIGS_TO_BACKUP=(
    "hypr"
    "waybar"
    "wlogout"
    "wofi"
)

# --- Create Backup Directory ---
mkdir -p "$BACKUP_DIR" || { echo "Error: Failed to create backup directory."; exit 1; }

# --- Perform Backup ---
for config in "${CONFIGS_TO_BACKUP[@]}"; do
    SOURCE_PATH="${HOME}/.config/${config}"
    DEST_PATH="${BACKUP_DIR}/"

    if [ -d "$SOURCE_PATH" ] || [ -f "$SOURCE_PATH" ]; then
        cp -rv "$SOURCE_PATH" "$DEST_PATH" &>/dev/null # Suppress cp's verbose output
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to backup ${config}."
        fi
    fi
done

echo "Backup complete. Saved to: ${BACKUP_DIR}"
