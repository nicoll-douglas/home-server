#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="/home/jiggy"

# import .env
set -a
source .env
set +a

# exit on error
set -e

# create necessary folders + files
mkdir -p $SYNCTHING_DIR/data
mkdir -p $SYNCTHING_DIR/config
mkdir -p $FILEBROWSER_DIR
touch $FILEBROWSER_DIR/database.db

# switch to current directory
cd $SERVICE_DIR

echo "Starting Syncthing and File Browser containers..."
docker compose up -d