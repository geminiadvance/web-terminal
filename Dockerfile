FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# 1. Clear dpkg path-exclusions to allow man page installation
RUN rm -f /etc/dpkg/dpkg.cfg.d/excludes \
    && sed -i '/path-exclude=\/usr\/share\/man/d' /etc/dpkg/dpkg.cfg.d/* 2>/dev/null || true

# 2. Update indices and install man-db, less (pager), and core tools
RUN apt-get update && apt-get install -y --reinstall \
    ca-certificates \
    curl \
    wget \
    git \
    vim \
    nano \
    sudo \
    bash \
    less \
    util-linux \
    bsdmainutils \
    man-db \
    manpages \
    manpages-dev \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# 3. Explicitly build the manual page index
RUN mandb -c

# 4. Install ttyd web terminal
RUN curl -sLO https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x ttyd.x86_64 \
    && mv ttyd.x86_64 /usr/local/bin/ttyd

WORKDIR /root

ENV TERM=xterm-256color
ENV PAGER=less

EXPOSE 10000

CMD ttyd -p 10000 -c "$TTYD_USER:$TTYD_PASS" -W bash
