#!/bin/bash
set -e

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Default to the latest published CLIs if no pin is provided
CLAUDE_CODE_VERSION="${CLAUDE_CODE_VERSION:-latest}"
CODEX_VERSION="${CODEX_VERSION:-latest}"

# Node.js (with npm) is required to install the AI coding CLIs.
node_major=0
if command -v node >/dev/null 2>&1; then
  node_major="$(node -p 'process.versions.node.split(".")[0]')"
fi

if [ "${node_major}" -lt 18 ]; then
  # Install Node.js LTS (via NodeSource)
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
  apt-get install -y nodejs
  node_major="$(node -p 'process.versions.node.split(".")[0]')"
fi

if [ "${node_major}" -lt 18 ]; then
  echo "Node.js 18+ is required, but found $(node --version). Check NodeSource apt setup." >&2
  exit 1
fi

# Install the Anthropic Claude Code and OpenAI Codex CLIs globally
npm install -g "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}"
npm install -g "@openai/codex@${CODEX_VERSION}"

# Smoke-test the installs (non-fatal so the build still succeeds offline)
claude --version || true
codex --version || true

echo "AI CLI installation completed"
