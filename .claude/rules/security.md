---
description: セキュリティ関連の設定
globs:
---

`.claude/settings.json` で以下のファイルの読み取りを拒否している:
- `.env`, `.env.*` — 環境変数・シークレット
- `*.pem`, `*.key` — 証明書・秘密鍵
- `credentials.json` — 認証情報
- `secrets/**` — シークレットディレクトリ
