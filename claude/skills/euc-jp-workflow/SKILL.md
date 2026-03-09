---
name: euc-jp-workflow
description: EUC-JPのPHP/.tpl編集時にnkf変換ワークフローを適用する。colorme-admin、colorme-userの編集時、文字化け、nkf、EUC-JPの言及時に使用。直接編集を禁止し文字化けを防ぐ。
---

# EUC-JP エンコーディング対応

PHP / .tpl が EUC-JP のプロジェクトでは、直接編集すると文字化けする。必ず以下に従う。

## 編集ワークフロー

```bash
# 1. UTF-8 に変換
nkf -w path/to/file.php > path/to/file.php.utf8

# 2. .utf8 を編集（元は触らない）

# 3. EUC-JP に戻す
nkf -e path/to/file.php.utf8 > path/to/file.php

# 4. 一時ファイル削除
rm path/to/file.php.utf8
```

## ルール

- 直接編集禁止
- 対象: `app/`、`tests/`、`*.tpl`
- 絵文字禁止（EUC-JP 非対応）
- 文字化け時: `git checkout path/to/file.php`

## 参照

[nkf コマンド一覧](reference.md)
