#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# exit on error
set -e

# switch to directory
cd $SERVICE_DIR

echo "Starting syncthing container..."
docker compose up -d