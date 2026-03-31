# claude-saves

Claude Code ユーティリティ集。

## ツール一覧

| ツール | 説明 |
|--------|------|
| [claude-saves](./claude-saves) | セッションを tmux と連携して管理 |
| [claude-statusline](./claude-statusline/) | ステータスラインにモデル名・コンテキスト・レート制限をゲージ表示 |

---

# claude-saves

Claude Code のセッションを tmux と連携して管理するツール。

tmux セッションと Claude Code のセッションを自動で紐付けて、会話の続きをいつでも再開できます。

## 課題

Claude Code のセッションはプロセスIDに紐づいているため、ターミナルを閉じたり tmux をデタッチすると、元の会話に戻る方法がありません。

## 解決

`claude-saves` は tmux セッションと Claude Code のセッションIDを自動でマッピングします。

- **会話の再開** — 前回の続きからそのまま再開
- **複数ワークスペース** — tmux ウィンドウごとに別の Claude セッションを管理
- **自動保存** — Claude 起動後にセッションIDを自動取得・保存
- **tmux-resurrect対応** — tmux-resurrect と組み合わせて環境ごと復元

## インストール

```bash
git clone https://github.com/TOKUMAINOUE/claude-saves.git
cd claude-saves
bash install.sh
```

手動インストール:

```bash
curl -fsSL https://raw.githubusercontent.com/TOKUMAINOUE/claude-saves/main/claude-saves -o /usr/local/bin/claude-saves
chmod +x /usr/local/bin/claude-saves
```

### 必要なもの

- [tmux](https://github.com/tmux/tmux) — 必須。未インストールの場合は自動でインストールを案内します
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — 必須
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) — 任意。セッション環境の完全復元に使用

## 使い方

```bash
claude-saves              # セッション選択画面を開く
claude-saves new          # 新規セッションを作成
claude-saves list         # セッション一覧を表示
claude-saves kill         # セッションをキル
claude-saves restore      # tmux-resurrectから復元
claude-saves --help       # ヘルプを表示
```

### インタラクティブモード

`claude-saves` を実行するだけ:

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

### セッションステータス

| ステータス | 意味 |
|-----------|------|
| `● Claude実行中` | このセッションで Claude Code が動作中 |
| `○ 復元可` | セッションデータあり。再開可能 |
| `○ 期限切れ` | セッションデータが期限切れまたは削除済み |
| `○ マッピングなし` | Claude との紐付けがない tmux セッション |

## 仕組み

1. **作成** — 新規セッション作成時に tmux セッションを起動し、Claude Code を開始
2. **取得** — Claude 起動後、`~/.claude/sessions/<pid>.json` から実際のセッションIDを取得して `~/.config/claude-saves/sessions/<name>` に保存
3. **復元** — 既存セッションを選択すると、Claude が実行中か確認。停止中なら `claude --resume <session-id>` で会話を復元
4. **フォールバック** — セッションデータが期限切れの場合は新規 Claude インスタンスを起動し、新しいセッションIDを保存

## 設定

環境変数:

| 変数 | デフォルト | 説明 |
|------|-----------|------|
| `CLAUDE_SAVES_WORKDIR` | カレントディレクトリ | 新規セッションの作業ディレクトリ |
| `CLAUDE_SAVES_CONFIG` | `~/.config/claude-saves` | 設定・セッションデータの保存先 |

## ライセンス

MIT
