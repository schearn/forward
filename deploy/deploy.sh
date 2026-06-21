#!/bin/bash
# Deploy the Forward site to its droplet. Run from the Forward project root:
#   FORWARD_DROPLET=root@NEW_IP ./deploy/deploy.sh
# Defaults to the ~/droplet_key SSH key (add droplet_key.pub to the droplet on create).
set -e

DROPLET="${FORWARD_DROPLET:-root@CHANGE_ME_DROPLET_IP}"
KEY="${FORWARD_KEY:-$HOME/droplet_key}"
DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [[ "$DROPLET" == *CHANGE_ME* ]]; then
  echo "Set the droplet IP first:  FORWARD_DROPLET=root@1.2.3.4 ./deploy/deploy.sh"
  exit 1
fi

echo "→ Uploading site to $DROPLET:/opt/forward ..."
ssh -i "$KEY" "$DROPLET" 'mkdir -p /opt/forward'
scp -i "$KEY" -r "$DIR/index.html" "$DIR/assets" "$DROPLET:/opt/forward/"
echo "✓ Live at https://forward.film"
