#!/bin/bash

service_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
network_name="nginx-proxy-net"
nginx_sites="../../config/nginx/sites"
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

sudo -u "$SUDO_USER" mkdir -vp $certs_dir

for file in $nginx_sites/*.conf; do
  domain_base=$(basename "${file%.conf}")
  cert_file="$certs_dir/$domain_base.pem"
  cert_key="$certs_dir/$domain_base-key.pem"

  if [ ! -f $cert_file ] || [ ! -f $cert_key ]; then
    rm -v "$certs_dir/*$domain_base*"

    echo "Generating TLS certificate for $domain_base.*"
    sudo -u "$SUDO_USER" mkcert \
      -cert-file $cert_file \
      -key-file $cert_key \
      $domain_base.lan $domain_base.dev
  else
    echo "Certificate exists for $domain_base.*, skipping..."
  fi
done

sudo -u "$SUDO_USER" mkdir -vp $logs_dir

if ! sudo docker network inspect "$network_name" >/dev/null 2>&1; then
  echo "Creating external network '$network_name'..."
  sudo docker network create "$network_name"
fi

echo "Starting nginx and cloudflared containers..."
sudo docker compose up -d
