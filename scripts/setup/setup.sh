echo "Installing and setting up homelab repo"

echo "Creating group 'homelab'"
sudo groupadd homelab

echo "Adding current user to group 'homelab'"
sudo usermod -aG homelab $SUDO_USER

echo "Creating user 'ci'"
sudo adduser ci

echo "Adding ci user to group 'homelab'" 
sudo usermod -aG homelab ci

echo "Creating directory: /srv/homelab"
cd /srv
sudo mkdir homelab

echo "Changing owernship to '$SUDO_USER:homelab' with setGID bit"
sudo chown $SUDO_USER:homelab homelab
sudo chmod 2775 homelab

echo "Cloning homelab repository"
cd homelab
sudo -u "$SUDO_USER" git clone https://github.com/nicoll-douglas/homelab.git .

echo "Creating .env scaffolding for services"
for dir in services/*/; do
  [ -d "$dir" ] || continue

  find ../services -type f -name ".env.example" -exec dirname {} \; | sort -u | while IFS= read -r dir; do
    echo "Creating .env file in service directory: $dir"
    cp $dir/.env.example $dir/.env
    chmod 640 $dir/.env
  done
done
