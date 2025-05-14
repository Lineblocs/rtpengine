#!/bin/bash
: ${CLOUD=""} # One of aws, azure, do, gcp, or empty
if [ "$CLOUD" != "" ]; then
   PROVIDER="-provider ${CLOUD}"
fi

PRIVATE_IPV4=$(netdiscover -field privatev4 ${PROVIDER})
PUBLIC_IPV4=$(netdiscover -field publicv4 ${PROVIDER})
if [[ -z "${BIND_ADDR}" ]]; then
   export BIND_ADDR="udp:127.0.0.1:7722"
fi
if [[ -z "${UDP_PORT_RANGE_LOW}" ]]; then
   export UDP_PORT_RANGE_LOW="30000"
fi
if [[ -z "${UDP_PORT_RANGE_HIGH}" ]]; then
   export UDP_PORT_RANGE_HIGH="40000"
fi
if [[ -z "${LOG_LEVEL}" ]]; then
   export LOG_LEVEL="INFO"
fi
set -e

# Optional: show interface info
echo "Interface info:"
ip a

# Optional: sleep until network is ready
sleep 1

# Start rtpengine in foreground so logs are visible
exec /rtpengine/daemon/rtpengine \
  --interface=$PUBLIC_IPV4 \
  --listen-ng=127.0.0.1:2223 \
  --port-min=30000 \
  --port-max=40000 \
  --log-level=7 \
  --foreground
  --no-fallback
