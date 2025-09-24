#!/bin/bash

# Vibe Coding Sandbox Entrypoint Script

echo "🎵 Starting Vibe Coding Sandbox..."

# Start Tailscale daemon in the background if TAILSCALE_AUTHKEY is provided
if [ ! -z "$TAILSCALE_AUTHKEY" ]; then
    echo "🔗 Starting Tailscale..."
    sudo tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
    sleep 2
    tailscale up --authkey=$TAILSCALE_AUTHKEY --hostname=${HOSTNAME:-vibe-box}
fi

# Set up git configuration if provided
if [ ! -z "$GIT_USER_NAME" ]; then
    git config --global user.name "$GIT_USER_NAME"
fi

if [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
fi

# Set up Claude CLI if API key is provided
if [ ! -z "$CLAUDE_API_KEY" ]; then
    echo "🤖 Configuring Claude CLI..."
    mkdir -p ~/.config/claude
    echo "$CLAUDE_API_KEY" > ~/.config/claude/api_key
fi

# Start services that need to run in background
echo "🚀 Starting background services..."

# Start FrankenPHP server if requested
if [ "$START_FRANKENPHP" = "true" ]; then
    echo "🐘 Starting FrankenPHP server..."
    cd /home/vibe/workspace
    frankenphp serve --listen :8080 &
fi

# Create some useful directories
mkdir -p /home/vibe/workspace/projects
mkdir -p /home/vibe/.config

echo "✅ Vibe Coding Sandbox is ready!"
echo "📁 Workspace: /home/vibe/workspace"
echo "🛠️  Available tools: node, pnpm, php, frankenphp, claude, tailscale, zsh"

# Execute the main command
exec "$@"