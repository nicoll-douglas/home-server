#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NETWORK_NAME="cloudflare-tunnel-net"

set -e

cd $SERVICE_DIR

if sudo docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "Network '$NETWORK_NAME' is in place."
else
  echo "Creating network '$NETWORK_NAME'..."
  sudo docker network create "$NETWORK_NAME"
fi

echo "Starting cloudflared..."
sudo docker compose up -d
