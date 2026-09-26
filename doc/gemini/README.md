# Gemini CLI / Antigravity CLI configuration

Gemini CLI / Antigravity CLI（`agy`）関連の設定を管理します。どちらも `~/.gemini/` を使います。

- `GEMINI.md`: `~/.gemini/GEMINI.md` にシンボリックリンクされ、グローバルのルールとして読まれます。

## Skills

`~/.gemini/antigravity-cli/skills` にシンボリックリンクされます（Antigravity CLI のグローバルスキルの置き場所）。

### dotfiles-expert
このリポジトリの構造や規約（Fish プロンプト、Neovim 設定、カラーパレットなど）をエージェントに理解させるためのスキルです。

### refactor-expert
コードの可読性や保守性を向上させるための専門スキルです。設定の分割や古い記法の更新など、リファクタリングを行う際に使用します。

### secret-guard
リポジトリ内に機密情報（APIキー、トークンなど）が混入していないかチェックするためのセキュリティスキルです。
