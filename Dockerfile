# Use Ubuntu as base image for better compatibility
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=20
ENV PNPM_VERSION=8.15.6
ENV SHELL=/usr/bin/zsh

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    sudo \
    zsh \
    vim \
    nano \
    htop \
    unzip \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and pnpm
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pnpm@${PNPM_VERSION}

# Install FrankenPHP
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then ARCH="x86_64"; fi \
    && if [ "$ARCH" = "arm64" ]; then ARCH="aarch64"; fi \
    && curl -fsSL "https://github.com/dunglas/frankenphp/releases/latest/download/frankenphp-linux-${ARCH}" -o /usr/local/bin/frankenphp \
    && chmod +x /usr/local/bin/frankenphp

# Install PHP (required for FrankenPHP)
RUN add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
    php8.2 \
    php8.2-cli \
    php8.2-common \
    php8.2-curl \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI and Codex (as root)
RUN npm install -g @anthropic-ai/claude-code
RUN npm install -g @openai/codex

# Create a non-root user
RUN useradd -m -s /usr/bin/zsh -G sudo vibe \
    && echo 'vibe ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER vibe
WORKDIR /home/vibe

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Create workspace directory
RUN mkdir -p /home/vibe/workspace

# Set up basic zsh configuration
RUN echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc \
    && echo 'export EDITOR=vim' >> ~/.zshrc \
    && echo 'alias ll="ls -la"' >> ~/.zshrc \
    && echo 'alias la="ls -A"' >> ~/.zshrc \
    && echo 'alias l="ls -CF"' >> ~/.zshrc

# Create entrypoint script
COPY --chown=vibe:vibe entrypoint.sh /home/vibe/
RUN chmod +x /home/vibe/entrypoint.sh

# Expose common ports
EXPOSE 3000 8000 8080 80 443

# Set the entrypoint
ENTRYPOINT ["/home/vibe/entrypoint.sh"]
CMD ["zsh"]