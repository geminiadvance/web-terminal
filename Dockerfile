FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Restore man pages and documentation (removed by default in slim images)
RUN rm -f /etc/dpkg/dpkg.cfg.d/excludes

# Install common utilities including man, cal, and standard tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    vim \
    nano \
    sudo \
    bash \
    man-db \
    manpages \
    manpages-dev \
    util-linux \
    bsdmainutils \
    && rm -rf /var/lib/apt/lists/*

# Rebuild man-db database so 'man <command>' works
RUN mandb

# Download pre-built ttyd binary directly from GitHub
RUN curl -sLO https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x ttyd.x86_64 \
    && mv ttyd.x86_64 /usr/local/bin/ttyd

WORKDIR /root

ENV TERM=xterm-256color

EXPOSE 10000

CMD ["ttyd", "-p", "10000", "-W", "bash"]
