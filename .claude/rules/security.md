---
description: セキュリティ関連の設定
globs:
---

シークレット類の保護はグローバル設定 `~/.claude/settings.json` に集約している（全リポジトリ・全環境で有効）:
- 読み取り拒否: `.env` / `.env.*` / `*.pem` / `*.key` / `*.p12` / `credentials(.json)` / `secrets/**` / `id_rsa` / `id_ed25519` / `~/.ssh` / `~/.aws` / `~/.netrc` / `~/.npmrc`
- 編集・書き込み拒否: `.env` / `.env.*` / `secrets/**`
- Bashフックで危険な削除（`/` `~` `$HOME` 等の削除）と外部アップロードサービスへの送信をブロック

このリポジトリの `.claude/settings.json` は上記をグローバルに委譲したため空（`{}`）。dotfiles固有の追加設定が必要になったらここに書く。
