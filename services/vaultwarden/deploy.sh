#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# exit on error
set -e

# import symlinked .env vars
set -a
source .env
set +a

# create vaultwarden dir in syncthing data dir
mkdir -p $DATA_DIR

# switch to current directory
cd $SERVICE_DIR

echo "Starting Vaultwarden container..."
docker compose up -d