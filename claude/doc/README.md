# Claude Code 設定

Claude Code 関連の設定を管理します。`setup-dotfiles.sh` により `~/.claude/` 配下にシンボリックリンクされます。

## 構造

```
claude/
├── CLAUDE.md   # グローバル設定（rulesに分割済みなので最小）
├── rules/      # 恒常ルール（毎セッション自動ロード）
├── skills/     # 明示的に呼び出すワークフロー
└── commands/   # スラッシュコマンド
```

方針は [Zenn: Claude Code の rules / skills を分割してコンテキストを83%削減した話](https://zenn.dev/pepabo/articles/claude-code-rules-skills-split) を参考。

職場固有の skills / commands は別リポジトリ（dotfiles-pepabo 等）に分離し、setup-dotfiles.sh は per-item symlink で両方の内容を `~/.claude/skills` / `~/.claude/commands` に合流させる構成。

## Rules（常時適用）

| ルール | 用途 |
|--------|------|
| basics | 基本的な会話・作業方針 |
| clipboard | クリップボードコピーの発動条件 |
| coding-style | コードの書き方ルール |
| commit | コミットメッセージの方針 |
| edit-over-write | 既存ファイルはEdit優先 |
| encoding | ファイルエンコーディングの扱い |
| environment | 実行環境（OS / shell / editor） |
| no-external-upload | 外部アップロードの禁止 |
| pr-style | PR本文の方針 |
| response-style | 回答スタイル |
| small-commits | コミット粒度 |
| use-templates | テンプレートの尊重 |

## Skills（明示的に呼び出し）

| スキル | 用途 |
|--------|------|
| code-style-quality | コードスタイル・品質ルール |
| commit-message | 日本語コミットメッセージ生成 |
| dotfiles-expert | dotfiles リポジトリの構造・規約理解 |
| empirical-prompt-tuning | プロンプトを反復改善する手法 |
| explain | コードの処理フロー解説 |

## Commands

| コマンド | 用途 |
|----------|------|
| /copy | 調査・ドキュメント作成してクリップボードにコピー |
| /diff | ブランチの変更内容を日本語で要約 |
| /fix-review | PRのレビューコメント修正 |
| /handoff | セッションの引き継ぎメモ保存 |
| /parallel | 並列にworkerを起動して作業分割 |
| /pr | 現在のブランチからPR作成 |
| /review | ブランチの変更内容をレビュー |
| /test | 関連テストの実行 |
