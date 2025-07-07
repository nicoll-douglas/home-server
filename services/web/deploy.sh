#!/bin/bash

service_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
network_name="nginx-proxy-net"
nginx_sites="../../config/nginx/sites"
certs_dir="./certs"
logs_dir="../../logs/nginx"

set -e

cd $service_dir

echo "Generating TLS certificates..."

sudo -u "$SUDO_USER" mkdir -vp $certs_dir

for file in "$nginx_sites"/*.conf; do
  domain=$(basename "${file%.conf}")
  cert_file="$certs_dir/$domain.pem"
  cert_key="$certs_dir/$domain-key.pem"

  if [ ! -f $cert_file ] || [ ! -f $cert_key ]; then
    rm -vf "$certs_dir/*$domain*"

    echo "Generating TLS certificate for: $domain"
    sudo -u "$SUDO_USER" mkcert \
      -cert-file $cert_file \
      -key-file $cert_key \
      $domain
  else
    echo "Certificate exists for $domain, skipping..."
  fi
done

sudo -u "$SUDO_USER" mkdir -vp $logs_dir

if ! sudo docker network inspect "$network_name" >/dev/null 2>&1; then
  echo "Creating external network '$network_name'..."
  sudo docker network create "$network_name"
fi

echo "Starting nginx and cloudflared containers..."
sudo docker compose up -d
