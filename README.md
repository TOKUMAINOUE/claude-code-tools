# claude-code-tools

Claude Code ユーティリティ集。

## ツール一覧

| ツール | 説明 |
|--------|------|
| [claude-saves](./claude-saves/) | セッションを tmux と連携して管理 |
| [claude-statusline](./claude-statusline/) | ステータスラインにモデル名・コンテキスト・レート制限をゲージ表示 |
| [school-presentation-script](./school-presentation-script/) | 学校説明会プレゼン台本 |

## インストール

各ツールは独立しています。使いたいツールのディレクトリに入って `install.sh` を実行してください。

```bash
git clone https://github.com/TOKUMAINOUE/claude-code-tools.git
cd claude-code-tools

# claude-saves をインストール
cd claude-saves && bash install.sh

# claude-statusline をインストール
cd claude-statusline && bash install.sh
```

## ライセンス

MIT
