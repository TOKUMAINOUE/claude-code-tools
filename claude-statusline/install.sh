#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.claude/statusline-command.sh"
SETTINGS="$HOME/.claude/settings.json"

echo "=== claude-statusline installer ==="

# 0. jq check & install
if ! command -v jq &>/dev/null; then
    echo "[0] jq not found. Installing..."
    if command -v brew &>/dev/null; then
        brew install jq
    elif command -v apt-get &>/dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y -qq jq
    elif command -v yum &>/dev/null; then
        sudo yum install -y jq
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm jq
    else
        echo "Error: jq をインストールできません。手動でインストールしてください: https://jqlang.github.io/jq/"
        exit 1
    fi
    echo "    jq installed"
fi

# 1. Copy script
mkdir -p "$HOME/.claude"
cp "$SCRIPT_DIR/statusline.sh" "$DEST"
chmod +x "$DEST"
echo "[1/2] statusline.sh -> $DEST"

# 2. Update settings.json
if [ -f "$SETTINGS" ]; then
    if grep -q '"statusLine"' "$SETTINGS"; then
        echo "[2/2] settings.json already has statusLine config. Skipping."
        echo "      If display is broken, replace the statusLine command with:"
        echo "      \"command\": \"bash $DEST\""
    else
        # Add statusLine before the last closing brace
        tmp=$(mktemp)
        sed '$ d' "$SETTINGS" > "$tmp"
        echo '  ,"statusLine": {' >> "$tmp"
        echo "    \"type\": \"command\"," >> "$tmp"
        echo "    \"command\": \"bash $DEST\"" >> "$tmp"
        echo '  }' >> "$tmp"
        echo '}' >> "$tmp"
        mv "$tmp" "$SETTINGS"
        echo "[2/2] settings.json updated"
    fi
else
    cat > "$SETTINGS" << EOF
{
  "statusLine": {
    "type": "command",
    "command": "bash $DEST"
  }
}
EOF
    echo "[2/2] settings.json created"
fi

echo ""
echo "Done! Restart Claude Code to see the statusline."
