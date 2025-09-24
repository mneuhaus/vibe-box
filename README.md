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

## Docker Hub

The image is available on Docker Hub: `neuhausnrw/vibe-box`

### Using Pre-built Image

```bash
# Pull and run the latest image
docker run -it --privileged -p 3000:3000 -p 8080:8080 neuhausnrw/vibe-box

# Or use docker-compose (update image name in docker-compose.yml)
docker-compose up -d
```

### Building Locally

```bash
docker build -t neuhausnrw/vibe-box .
docker run -it --privileged -p 3000:3000 -p 8080:8080 neuhausnrw/vibe-box
```

### GitHub Actions

The repository includes a GitHub Action that automatically:
- Builds AMD64 images (ARM64 support planned)
- Pushes to Docker Hub on every commit to main
- Creates tagged releases for version tags (v1.0.0, etc.)

**Setup Requirements:**
1. Add GitHub repository secrets:
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub password or access token

## Traefik Integration

The docker-compose file includes Traefik labels for automatic HTTPS setup. Adjust the `Host` rule to match your domain.

## Usage with Tailscale

1. Get an auth key from your Tailscale admin console
2. Set the `TAILSCALE_AUTHKEY` environment variable
3. Your container will automatically join your Tailscale network

## Workspace

The `/home/vibe/workspace` directory is mounted as a volume for persistent development files.