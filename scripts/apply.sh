#!/bin/bash

echo "Applying Dotfiles..."

# Define the source directory for your dotfiles
# Using an absolute path or a path relative to the script's location is generally safer
DOTFILES_SOURCE="$(dirname "$0")/../config" # Assumes script is in a 'scripts' or similar dir next to 'config'

# --- Function to copy a configuration directory ---
copy_config() {
    local config_name="$1"
    local source_path="${DOTFILES_SOURCE}/${config_name}"
    local dest_path="${HOME}/.config/${config_name}"

    if [ -d "$source_path" ]; then
        echo "Copying ${config_name}..."
        # Create destination directory if it doesn't exist
        mkdir -p "$dest_path"
        # Use -r for recursive copy (for directories) and -u for update (only copy when source is newer or dest doesn't exist)
        # Using -v for verbose output
        cp -rv "$source_path/"* "$dest_path/" || { echo "Error: Failed to copy ${config_name}. Aborting."; exit 1; }
    elif [ -f "$source_path" ]; then
        echo "Copying ${config_name} file..."
        cp -v "$source_path" "$dest_path" || { echo "Error: Failed to copy ${config_name}. Aborting."; exit 1; }
    else
        echo "Warning: Source for ${config_name} not found at $source_path. Skipping."
    fi
}

# --- Apply configs ---
copy_config "hypr"
copy_config "waybar"
copy_config "wlogout"
copy_config "wofi"
copy_config "themes"

echo "Dotfiles applied."

echo "Reloading Hyprland..."

# Check if hyprctl is available and if Hyprland is running
if command -v hyprctl &> /dev/null; then
    if hyprctl reload &> /dev/null; then
        echo "Hyprland reloaded successfully."
    else
        echo "Warning: Failed to reload Hyprland. It might not be running or an error occurred."
    fi
else
    echo "Warning: 'hyprctl' command not found. Cannot reload Hyprland."
fi

echo "Script finished."
