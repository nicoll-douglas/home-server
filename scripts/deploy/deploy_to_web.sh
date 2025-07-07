#!/bin/bash

service_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
network_name="nginx-proxy-net"

# exit on error
set -e

# switch to directory
cd $service_dir

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

if docker network inspect "$network_name" >/dev/null 2>&1; then
  echo "Network '$network_name' is in place."
else
  echo "Creating external network '$network_name'..."
  docker network create "$network_name"
fi

echo "Creating and starting new containers..."
docker compose up -d --remove-orphans

echo "Cleaning up unusued images..."
docker image prune -af

echo "Logging out of docker..."
docker logout

echo "Deployment complete."