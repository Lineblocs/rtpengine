FROM debian:bullseye

# Install dependencies
RUN apt update && apt install -y \
    iptables iproute2 libpcap-dev libcurl4-openssl-dev \
    libssl-dev daemonize make gcc g++ git wget \
    pkg-config \
    gperf \
    pandoc \
    libglib2.0-dev \
    libjson-glib-dev \
    libavcodec-dev \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev \
    libevent-dev \
    libiptc-dev \
    libmnl-dev \
    libnftnl-dev \
    libpcre2-dev \
    libswresample-dev \
    libwebsockets-dev \
    zlib1g-dev \
    libncurses-dev \
    libopus-dev \
    libspandsp-dev \
    libxmlrpc-core-c3-dev \
    default-libmysqlclient-dev \
    libhiredis-dev \
    xmlstarlet \
    bc

# Clone and build RTPengine
RUN git clone https://github.com/sipwise/rtpengine.git /rtpengine && \
    cd /rtpengine && \
    make -C daemon

# 💡 Copy your custom entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 💡 Use the script as the container entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
