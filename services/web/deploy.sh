#!/bin/bash

SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NETWORK_NAME="nginx-proxy-net"
DOMAINS_FILE="../../config/nginx/domains"
CERT_DIR="./certs"
CERT_NAME="server"
LOGS_DIR="../../logs/nginx"

set -e

cd $SERVICE_DIR

if [ ! -f /usr/local/bin/mkcert ]; then
  echo "Installing mkcert..."
  sudo apt install libnss3-tools
  curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
  chmod +x mkcert-v*-linux-amd64
  sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert
fi

if ! [ -f $CERT_FILE  ] || ! [ -f $CERT_KEY ]; then
  echo "Generating SSL certificate..."
  domains=$(cat $DOMAINS_FILE | xargs)

  if [ -z "$domains" ]; then
    echo "No domains found in $DOMAINS_FILE"
    exit 1
  fi

  mkdir -p ./certs
  mkcert -cert-file "$CERT_DIR/$CERT_NAME.pem" \
    -key-file "$CERT_DIR/$CERT_NAME-key.pem" \
    $domains
fi

echo "Creating logs directory if it doesn't exist..."
mkdir -p $LOGS_DIR

if ! sudo docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "Creating external network '$NETWORK_NAME'..."
  sudo docker network create "$NETWORK_NAME"
fi

echo "Starting nginx and cloudflared containers..."
sudo docker compose up -d
