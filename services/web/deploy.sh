#!/bin/bash

service_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
network_name="nginx-proxy-net"
domains_file="../../config/nginx/domains"
certs_dir="./certs"
logs_dir="../../logs/nginx"

set -e

cd $service_dir

if [ ! -f /usr/local/bin/mkcert ]; then
  echo "Installing mkcert..."
  sudo apt install -y libnss3-tools
  curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
  chmod +x mkcert-v*-linux-amd64
  sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert
fi

echo "Generating TLS certificates..."
domains=$(cat $domains_file | xargs)

if [ -z "$domains" ]; then
  echo "No domains found in $domains_file"
  exit 1
fi

echo "Creating certs directory if it doesn't exist..."
sudo -u "$SUDO_USER" mkdir -p $certs_dir

for domain in $domains; do
  cert_file="$certs_dir/$domain.pem"
  cert_key="$certs_dir/$domain-key.pem"

  if [ ! -f $cert_file ] || [ ! -f $cert_key ]; then
    echo "Generating TLS certificate for $domain"
    sudo -u "$SUDO_USER" mkcert \
      -cert-file $cert_file \
      -key-file $cert_key \
      $domain
  else
    echo "Certificate exists for $domain, skipping..."
  fi
done

echo "Creating logs directory if it doesn't exist..."
sudo -u "$SUDO_USER" mkdir -p $logs_dir

if ! sudo docker network inspect "$network_name" >/dev/null 2>&1; then
  echo "Creating external network '$network_name'..."
  sudo docker network create "$network_name"
fi

echo "Starting nginx and cloudflared containers..."
sudo docker compose up -d
