#!/usr/bin/env bash
set -euo pipefail

# When this script is called, we know that the value of the consul key at $1 has just changed.
if [ -z "$1" ]; then
    echo "Error: Expected k/v path as argument. Exiting."
    exit 1
fi

# Look up the key -- 'true' means we want nginx running; anything else means we want it stopped.
NGINX_DESIRED_STATE=$(consul kv get $1)

# Some upper/lowercase tolerance
NGINX_DESIRED_STATE=$(echo $NGINX_DESIRED_STATE | awk '{print tolower($0)}')

if [[ $NGINX_DESIRED_STATE == 'true' ]]; then
    sudo systemctl start nginx;
else
    # Try the nice way; then kill it where it stands
    sudo systemctl stop nginx;
    sleep 10
    killall -9 nginx
fi
