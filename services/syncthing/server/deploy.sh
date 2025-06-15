#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="/home/jiggy"

# exit on error
set -e

# switch to home directory and create necessary folders + files
cd $HOME_DIR
mkdir -p syncthing/data
mkdir -p syncthing/config
mkdir -p filebrowser
touch filebrowser/database.db

# switch to current directory
cd $SERVICE_DIR

echo "Starting syncthing and filebrowser containers..."
docker compose up -d