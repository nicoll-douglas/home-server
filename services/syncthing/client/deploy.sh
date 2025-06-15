#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# import .env
set -a
source .env
set +a

# exit on error
set -e

# switch to syncthing directory and create necessary folders + files
mkdir -p $SYNCTHING_DIR/data
mkdir -p $SYNCTHING_DIR/config

# switch to directory
cd $SERVICE_DIR

echo "Starting Syncthing container..."
docker compose up -d