# Dockerfile
FROM ubuntu:24.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install Build Dependencies
# ADDED: pandoc (Required for generating man pages)
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    cmake \
    pkg-config \
    libglib2.0-dev \
    libjson-glib-dev \
    libssl-dev \
    libpcre3-dev \
    libxmlrpc-core-c3-dev \
    libhiredis-dev \
    gperf \
    libcurl4-openssl-dev \
    libevent-dev \
    libpcap-dev \
    libspandsp-dev \
    default-libmysqlclient-dev \
    libavcodec-dev \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev \
    libswresample-dev \
    libwebsockets-dev \
    libopus-dev \
    libip4tc-dev \
    libip6tc-dev \
    libiptc-dev \
    libxtables-dev \
    libmnl-dev \
    libncurses-dev \
    zlib1g-dev \
    libsystemd-dev \
    libjwt-dev \
    libmosquitto-dev \
    libbcg729-dev \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# 2. Clone Rtpengine (Latest)
WORKDIR /usr/src
RUN git clone https://github.com/sipwise/rtpengine.git

# 3. Compile
WORKDIR /usr/src/rtpengine/daemon
RUN make with_transcoding=yes with_iptables_option=no

# --- Final Stage ---
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Runtime Libraries
# ADDED: libevent-pthreads-2.1-7t64 (Fixes your crash), plus extra/openssl modules
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0t64 \
    libjson-glib-1.0-0 \
    libssl3 \
    libpcre3 \
    libxmlrpc-core-c3t64 \
    libhiredis1.1.0 \
    libcurl4t64 \
    libevent-2.1-7t64 \
    libevent-pthreads-2.1-7t64 \
    libevent-extra-2.1-7t64 \
    libevent-openssl-2.1-7t64 \
    libpcap0.8t64 \
    libspandsp2t64 \
    libmariadb3 \
    libmysqlclient21 \
    libavcodec60 \
    libavfilter9 \
    libavformat60 \
    libavutil58 \
    libswresample4 \
    libwebsockets19 \
    libopus0 \
    net-tools \
    iproute2 \
    iptables \
    libncurses6 \
    zlib1g \
    libsystemd0 \
    libjwt2 \
    libmosquitto1 \
    libbcg729-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy Binary
COPY --from=builder /usr/src/rtpengine/daemon/rtpengine /usr/local/bin/rtpengine

# Setup Dirs
RUN mkdir -p /var/spool/rtpengine
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
