# claude-statusline

Claude Code のステータスラインにモデル名・コンテキスト使用量・レート制限をゲージバー付きで常時表示するツール。

## 表示例

```
Opus 4.6 (1M context) │ ctx ██░░░░░░░░ 0.10M/1M │ 5h ███░░░░░░░ 31% reset 3h24m │ 7d ░░░░░░░░░░ 3% reset 6d22h15m
```

## 表示内容

| 項目 | 説明 |
|------|------|
| モデル名 | 現在使用中のモデル（Opus / Sonnet / Haiku） |
| ctx | コンテキストウィンドウ使用量（M単位 / 上限） |
| 5h | 5時間レート制限の使用率 + リセットまでの残り時間 |
| 7d | 7日間レート制限の使用率 + リセットまでの残り時間 |

## ゲージの色

- 緑: 50%未満
- 黄: 50-80%
- 赤: 80%以上

## インストール

```bash
git clone https://github.com/TOKUMAINOUE/claude-saves.git
cd claude-saves/claude-statusline
bash install.sh
```

Claude Code を再起動すると表示されます。

### 必要なもの

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- [jq](https://jqlang.github.io/jq/) — JSON解析に使用

## アンインストール

`~/.claude/settings.json` から `statusLine` の設定を削除してください。

## ライセンス

MIT
