FROM debian:bookworm-slim

# Install system dependencies, ttyd, and common terminal utilities
RUN apt-get update && apt-get install -y \
    ttyd \
    bash \
    curl \
    wget \
    git \
    vim \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /root

# Set environment variables for terminal styling
ENV TERM=xterm-256color

# Expose Render's default web port
EXPOSE 10000

# Launch ttyd on port 10000 with interactive bash
CMD ["ttyd", "-p", "10000", "-W", "bash"]
