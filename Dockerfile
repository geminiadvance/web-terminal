FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# 1. Enable manual pages extraction by removing dpkg exclusions
RUN rm -f /etc/dpkg/dpkg.cfg.d/excludes \
    && sed -i '/path-exclude=\/usr\/share\/man/d' /etc/dpkg/dpkg.cfg.d/* 2>/dev/null || true

# 2. Install man-db, less (pager required by man), and common Linux tools
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    wget \
    git \
    vim \
    nano \
    sudo \
    bash \
    less \
    procps \
    htop \
    tree \
    zip \
    unzip \
    python3 \
    util-linux \
    bsdmainutils \
    man-db \
    manpages \
    manpages-dev \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# 3. Force man-db database creation
RUN mandb -c

# 4. Install ttyd web terminal
RUN curl -sLO https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x ttyd.x86_64 \
    && mv ttyd.x86_64 /usr/local/bin/ttyd

WORKDIR /root

# Configure environment variables for colored output and pager support
ENV TERM=xterm-256color
ENV PAGER=less

EXPOSE 10000

# Secured entrypoint using environment variables from Render
CMD ttyd -p 10000 -c "$TTYD_USER:$TTYD_PASS" -W bash
