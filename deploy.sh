#!/bin/bash
set -euo pipefail
export PATH="/usr/local/dotnet:$PATH"
TARGET="deploy@10.1.0.247"
SSH="ssh -o StrictHostKeyChecking=no"
dotnet publish AckWeb.Api/AckWeb.Api.csproj -c Release -o /tmp/ackweb-publish
rsync -a --delete --no-group --omit-dir-times -e "$SSH" /tmp/ackweb-publish/ "$TARGET":/opt/ack-web/publish/api/
rm -rf /tmp/ackweb-publish
$SSH "$TARGET" "sudo systemctl restart ackweb"
echo "Deployed to ack-web"
