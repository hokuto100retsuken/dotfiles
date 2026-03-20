# Claude Code 設定

Claude Code 関連の設定を管理します。
`setup-dotfiles.sh` により `~/.claude/skills` にシンボリックリンクされます。

## Skills

| スキル | 用途 |
|--------|------|
| code-style-quality | コードスタイル・品質ルール |
| commit-message | 日本語コミットメッセージ生成 |
| debug | Rails アプリのデバッグ支援 |
| dotfiles-expert | dotfiles リポジトリの構造・規約理解 |
| euc-jp-workflow | PHP/.tpl の EUC-JP 編集ワークフロー |
| explain | コードの処理フロー解説 |
| response-style | 回答スタイル（常時適用） |

## Commands

| コマンド | 用途 |
|----------|------|
| /copy | 調査・ドキュメント作成してクリップボードにコピー |
| /pr | 現在のブランチからPR作成 |
| /review | ブランチの変更内容をレビュー |
| /test | 関連テストの実行 |
