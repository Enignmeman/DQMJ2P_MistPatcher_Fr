#!/bin/bash

# Configuration
REPO_API="https://api.github.com/repos/Enignmeman/DQMJ2Pro_Translation_FR/commits/corrections-FR"
REPO_URL="https://github.com/Enignmeman/DQMJ2Pro_Translation_FR/archive"
VERSION_FILE="version"
ARCHIVE_DIR="./archive"
SLEEP_INTERVAL=86400 # 24 hours in seconds

# Ensure the destination directory exists
mkdir -p "$ARCHIVE_DIR"

# 1. Read version on startup
CURRENT_VERSION=""
if [ -f "$VERSION_FILE" ]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE")
    echo "Startup: Loaded stored version - $CURRENT_VERSION"
else
    echo "Startup: No existing version file found."
fi

echo "Starting GitHub repo monitor..."
echo "Checking every 24 hours. Press [CTRL+C] to stop."

while true; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Checking for updates..."

    # Fetch latest SHA from GitHub
    LATEST_SHA=$(curl -s -H "Accept: application/vnd.github.VERSION.sha" "$REPO_API")

    # Basic error handling in case GitHub is unreachable or rate-limited
    if [ -z "$LATEST_SHA" ] || [[ "$LATEST_SHA" == *"message"* ]]; then
        echo "Error fetching SHA. Retrying on next cycle..."
        sleep $SLEEP_INTERVAL
        continue
    fi

    # 2. Compare against current version variable
    if [ "$LATEST_SHA" != "$CURRENT_VERSION" ]; then
        echo "New commit found: $LATEST_SHA"
        
        ZIP_URL="${REPO_URL}/${LATEST_SHA}.zip"
        DEST_FILE="${ARCHIVE_DIR}/${LATEST_SHA}.zip"
        
        echo "Downloading to $DEST_FILE ..."
        
        # -L is required to follow GitHub's redirect to the actual zip file
        if curl -L -s -o "$DEST_FILE" "$ZIP_URL"; then
            echo "Download successful."
            
            # 3. Download successful: overwrite version file
            echo "$LATEST_SHA" > "$VERSION_FILE"

            # 4. Delete previous zip file
            rm -f "${ARCHIVE_DIR}/${CURRENT_VERSION}.zip"
            echo "Previous version deleted."
            
            # 5. Update the in-memory variable to skip future downloads
            CURRENT_VERSION="$LATEST_SHA"
            echo "Update successful."
        else
            echo "Failed to download the zip file."
        fi
    else
        echo "No updates found. In-memory version is up to date."
    fi

    # Sleep for 24 hours
    sleep $SLEEP_INTERVAL
done
