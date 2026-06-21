#!/bin/bash
# Run this ONCE on a fresh Ubuntu 22.04/24.04 droplet, as root.
#   scp -i ~/droplet_key deploy/provision.sh deploy/Caddyfile root@NEW_IP:/root/
#   ssh -i ~/droplet_key root@NEW_IP 'bash /root/provision.sh'
set -e

echo "→ Installing Caddy..."
apt-get update
apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl gnupg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
  | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
  | tee /etc/apt/sources.list.d/caddy-stable.list
apt-get update
apt-get install -y caddy

echo "→ Setting up site directory and Caddyfile..."
mkdir -p /opt/forward
[ -f /root/Caddyfile ] && cp /root/Caddyfile /etc/caddy/Caddyfile

echo "→ Starting Caddy (auto HTTPS via Let's Encrypt)..."
systemctl enable caddy
systemctl restart caddy

echo "✓ Done. Upload the site to /opt/forward, then visit https://forward.film"
echo "  (DNS for forward.film must already point to this droplet's IP.)"
