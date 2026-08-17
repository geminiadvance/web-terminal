FROM debian:bookworm-slim

# Prevent interactive prompts during apt installation
ENV DEBIAN_FRONTEND=noninteractive

# Install ttyd and common utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    ttyd \
    bash \
    curl \
    wget \
    git \
    vim \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /root

# Enable color terminal support
ENV TERM=xterm-256color

# Expose port for Render
EXPOSE 10000

# Launch ttyd on port 10000 with interactive bash
CMD ["ttyd", "-p", "10000", "-W", "bash"]
