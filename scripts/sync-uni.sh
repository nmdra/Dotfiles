#!/bin/bash

# Description: Script to sync Documents/Y2S1 with remote Google Drive, excluding specified file types and directories.

# Define the source and destination directories
SOURCE_DIR=~/Documents/Y2S2
DEST_DIR=remote-gdrive:Y2S2

# Function to display help message
function display_help() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  --sync      Perform the actual synchronization"
    echo "  --dry-run   Perform a trial run with no changes made"
    echo "  --help, -h  Display this help message"
    echo
    echo "This script syncs the local directory Y2S2 with the remote Google Drive directory Y2S2,"
    echo "excluding specified file types and directories."
}

# Initialize the DRY_RUN and SYNC variables
DRY_RUN=""
SYNC=""

# Check for the --sync, --dry-run or --help/-h argument
if [ $# -eq 0 ]; then
    display_help
    exit 0
fi

for arg in "$@"
do
    case $arg in
        --sync)
            SYNC="sync"
            ;;
        --dry-run)
            DRY_RUN="--dry-run"
            ;;
        --help|-h)
            display_help
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            display_help
            exit 1
            ;;
    esac
done

# If neither --sync nor --dry-run is specified, display help
if [ -z "$SYNC" ] && [ -z "$DRY_RUN" ]; then
    display_help
    exit 0
fi

# Define rclone command with options
rclone sync --copy-links $SOURCE_DIR $DEST_DIR -P -v $DRY_RUN \
--exclude "*.mkv" \
--exclude "*.mp4" \
--exclude ".git/**" \
--exclude "*.ts" 

# Check if dry run was specified
if [ -n "$DRY_RUN" ]; then
    echo "Dry run mode enabled. No changes will be made."
else
    echo "Sync completed."
fi
