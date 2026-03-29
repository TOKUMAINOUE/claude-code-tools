# claude-saves

Claude Code session manager with tmux integration.

Automatically saves and restores Claude Code sessions across tmux sessions. Never lose your conversation context again.

## The Problem

Claude Code sessions are tied to process IDs that change every restart. When you detach from tmux or your terminal closes, there's no easy way to resume the exact conversation you were having.

## The Solution

`claude-saves` maps tmux sessions to Claude Code session IDs, so you can:

- **Resume conversations** — Pick up exactly where you left off
- **Multiple workspaces** — Run different Claude sessions in different tmux windows
- **Auto-recovery** — Session IDs are captured automatically after Claude starts
- **tmux-resurrect support** — Works with tmux-resurrect for full environment recovery

## Install

```bash
git clone https://github.com/TOKUMAINOUE/claude-saves.git
cd claude-saves
bash install.sh
```

Or manually:

```bash
curl -fsSL https://raw.githubusercontent.com/TOKUMAINOUE/claude-saves/main/claude-saves -o /usr/local/bin/claude-saves
chmod +x /usr/local/bin/claude-saves
```

### Requirements

- [tmux](https://github.com/tmux/tmux) — Required. Auto-install prompt if missing.
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — Required.
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) — Optional. For full session restore.

## Usage

```bash
claude-saves              # Interactive session picker
claude-saves new          # Create new session
claude-saves list         # List all sessions with status
claude-saves kill         # Kill a session
claude-saves restore      # Restore from tmux-resurrect
claude-saves --help       # Show help
```

### Interactive Mode

Just run `claude-saves`:

```
claude-saves v0.1.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  0) 新規セッション作成
  r) 保存済みセッションを復元
  k) セッションをキル

  1) my-project [復元可]
  2) experiments [期限切れ]
  3) debugging
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
選択 >
```

### Session Status

| Status | Meaning |
|--------|---------|
| `● Claude実行中` | Claude Code is running in this session |
| `○ 復元可` | Session data exists, can be resumed |
| `○ 期限切れ` | Session data expired or deleted |
| `○ マッピングなし` | tmux session without Claude mapping |

## How It Works

1. **Create** — When you create a new session, `claude-saves` starts a tmux session and launches Claude Code
2. **Capture** — After Claude starts, the actual session ID is captured from `~/.claude/sessions/<pid>.json` and saved to `~/.config/claude-saves/sessions/<name>`
3. **Resume** — When you select an existing session, it checks if Claude is still running. If not, it uses `claude --resume <session-id>` to restore the conversation
4. **Fallback** — If session data has expired, it starts a fresh Claude instance and saves the new session ID

## Configuration

Environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `CLAUDE_SAVES_WORKDIR` | Current directory | Working directory for new sessions |
| `CLAUDE_SAVES_CONFIG` | `~/.config/claude-saves` | Config and session data directory |

## License

MIT
