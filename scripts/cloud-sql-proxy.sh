#!/usr/bin/env zsh

# Cloud SQL Auth Proxy
# https://cloud.google.com/sql/docs/mysql/sql-proxy#mac-m1
(
  set -x; mkdir -p $HOME/cloud-sql-proxy &&
  LATEST_VERSION=$(curl -s https://api.github.com/repos/GoogleCloudPlatform/cloud-sql-proxy/releases | jq -c 'first(.[] | select(.tag_name | startswith("v2")))' | jq -r '.tag_name') &&
  curl -o $HOME/cloud-sql-proxy/cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/$LATEST_VERSION/cloud-sql-proxy.darwin.arm64 &&
  chmod +x $HOME/cloud-sql-proxy/cloud-sql-proxy
)
