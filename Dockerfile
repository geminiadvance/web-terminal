FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Remove dpkg exclusions so manual pages get installed properly
RUN rm -f /etc/dpkg/dpkg.cfg.d/excludes \
    && sed -i '/path-exclude=\/usr\/share\/man/d' /etc/dpkg/dpkg.cfg.d/* 2>/dev/null || true

# Install documentation, man pages, and essential tools
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    wget \
    git \
    vim \
    nano \
    sudo \
    bash \
    util-linux \
    bsdmainutils \
    man-db \
    manpages \
    manpages-dev \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# Rebuild man page database
RUN mandb -c

# Install ttyd
RUN curl -sLO https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x ttyd.x86_64 \
    && mv ttyd.x86_64 /usr/local/bin/ttyd

WORKDIR /root

ENV TERM=xterm-256color

EXPOSE 10000

# Require username and password using the -c flag (username:password)
CMD ["ttyd", "-p", "10000", "-c", "gemini:Gemini@1234", "-W", "bash"]
