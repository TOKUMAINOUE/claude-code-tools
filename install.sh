#!/bin/bash
# claude-saves installer

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="/usr/local/bin"

echo "claude-saves をインストールします"
echo ""

# Copy to PATH
chmod +x "$REPO_DIR/claude-saves"

if [[ -w "$INSTALL_DIR" ]]; then
  cp "$REPO_DIR/claude-saves" "$INSTALL_DIR/claude-saves"
else
  echo "sudo が必要です"
  sudo cp "$REPO_DIR/claude-saves" "$INSTALL_DIR/claude-saves"
fi

echo "✓ claude-saves を $INSTALL_DIR にインストールしました"
echo ""
echo "使い方: claude-saves"
echo "ヘルプ: claude-saves --help"
