#!/bin/bash
# entrypoint.sh

# Dynamic Variables
INTERFACE=${INTERFACE:-eth0}
PUBLIC_IP=${PUBLIC_IP:-$(hostname -I | cut -d' ' -f1)}
LISTEN_PORT=${LISTEN_PORT:-22222}
MIN_PORT=${MIN_PORT:-30000}
MAX_PORT=${MAX_PORT:-50000}
RECORDING_DIR=${RECORDING_DIR:-/var/spool/rtpengine}

echo "Starting RTPengine on Ubuntu 24.04..."
echo "Binding to: $INTERFACE / $PUBLIC_IP"

# If we are using kernel mode (optional), we pass --table=0
# Otherwise, default to userspace
ARGS=""
if [ "$KERNEL_MODE" = "yes" ]; then
    ARGS="--table=0"
    echo "Kernel forwarding ENABLED"
fi

exec rtpengine \
    --interface=$INTERFACE/$PUBLIC_IP \
    --listen-ng=$LISTEN_PORT \
    --port-min=$MIN_PORT \
    --port-max=$MAX_PORT \
    --recording-dir=$RECORDING_DIR \
    --log-level=6 \
    --log-stderr \
    --foreground \
    $ARGS
