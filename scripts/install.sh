#!/bin/bash

sudo groupadd homelab
sudo usermod -aG homelab jiggy
sudo usermod -aG homelab ci
cd /srv
sudo mkdir homelab
sudo chown jiggy:homelab homelab
sudo chmod 2775 homelab
cd homelab
git clone https://github.com/nicoll-douglas/homelab.git .