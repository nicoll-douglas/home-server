#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NETWORK_NAME="nginx-proxy-net"

# exit on error
set -e

# switch to directory
cd $SERVICE_DIR

# import .env variables into shell environment
set -a
source .env
set +a

echo "Stopping and removing old containers..."
docker compose down || true

echo "Logging into Docker Hub with the configured credentials..."
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

echo "Pulling Docker images..."
docker compose pull

if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "Network '$NETWORK_NAME' is in place."
else
  echo "Creating external network '$NETWORK_NAME'..."
  docker network create "$NETWORK_NAME"
fi

echo "Creating and starting new containers..."
docker compose up -d --remove-orphans

echo "Cleaning up unusued images..."
docker image prune -af

echo "Logging out of docker..."
docker logout

echo "Deployment complete."