#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NETWORK_NAME="nginx-proxy-net"

set -e

cd $SERVICE_DIR

echo "Creating logs folder if it doesn't exist..."
mkdir -p ../../logs/nginx
sudo chmod -R u+w ../../logs/nginx

if sudo docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "Network '$NETWORK_NAME' is in place."
else
  echo "Creating external network '$NETWORK_NAME'..."
  sudo docker network create "$NETWORK_NAME"
fi

echo "Starting web service providers..."
sudo docker compose up -d
