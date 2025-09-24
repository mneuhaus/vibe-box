# Vibe Coding Sandbox Docker Image

A comprehensive Docker image for development environments with Node.js, FrankenPHP, Claude CLI, Tailscale, and more.

## Included Tools

- **Node.js 20** with pnpm package manager
- **FrankenPHP** - Modern PHP app server
- **Claude CLI** - Anthropic's Claude command-line interface
- **Tailscale** - Zero-config VPN
- **Zsh** with Oh My Zsh
- **Git**, vim, nano, htop, and other development essentials

## Quick Start

### Using Docker Run

```bash
docker build -t vibe-box .
docker run -it --privileged -p 3000:3000 -p 8080:8080 vibe-box
```

### Using Docker Compose

1. Copy and customize the environment variables in `docker-compose.yml`
2. Run: `docker-compose up -d`

## Environment Variables

- `TAILSCALE_AUTHKEY` - Your Tailscale auth key for automatic connection
- `GIT_USER_NAME` - Git username for commits
- `GIT_USER_EMAIL` - Git email for commits
- `CLAUDE_API_KEY` - Claude API key for CLI access
- `START_FRANKENPHP` - Set to "true" to auto-start FrankenPHP server

## Publishing to Docker Hub

1. Build the image: `docker build -t your-username/vibe-box .`
2. Push to Docker Hub: `docker push your-username/vibe-box`

## Traefik Integration

The docker-compose file includes Traefik labels for automatic HTTPS setup. Adjust the `Host` rule to match your domain.

## Usage with Tailscale

1. Get an auth key from your Tailscale admin console
2. Set the `TAILSCALE_AUTHKEY` environment variable
3. Your container will automatically join your Tailscale network

## Workspace

The `/home/vibe/workspace` directory is mounted as a volume for persistent development files.