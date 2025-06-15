#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="/media/jiggy/Shared"

# exit on error
set -e

# switch to syncthing parent directory and create necessary folders + files
cd $PARENT_DIR
mkdir -p syncthing/data
mkdir -p syncthing/config

# switch to directory
cd $SERVICE_DIR

echo "Starting syncthing container..."
docker compose up -d