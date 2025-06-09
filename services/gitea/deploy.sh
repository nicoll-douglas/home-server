#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set -e

cd $SERVICE_DIR

echo "Starting Gitea..."
sudo docker compose up -d