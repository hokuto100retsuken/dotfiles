---
name: commit-message
description: git diffを分析して日本語で簡潔なコミットメッセージを生成する。コミット、コミットログ、変更内容のまとめを依頼された時に使用。Whyを重視する。
---

# コミットメッセージ生成

## 形式

```
<簡潔な説明>

<Why（変更理由）>
```

プロジェクト規約で Conventional Commits（`feat/fix/...` プレフィックス）が指定されている場合のみ `<種類>(<スコープ>): <説明>` 形式にする。指定がなければ付けない。

## ルール

- **日本語**、1行目 50 文字以内（Conventional Commits 採用時はプレフィックス・スコープを含めた全体で 50 文字以内）
- **Why を書く**: What より Why を重視。本文の Why は「なぜこの変更が必要だったか（背景・動機）」を 1〜2 文で書く。実装詳細・API 名・ライブラリ名の列挙は不要
- **命令形**: 辞書形（終止形）を使う。OK: 「追加する」「防ぐ」「分割する」／ NG: 「追加した」「追加しました」「追加」

## 種類（Conventional Commits 採用時のみ）

feat / fix / refactor / docs / test / chore

## 手順

1. `git diff --staged` で変更確認
2. Why を推測
3. 上記形式で生成

## DO / DON'T

- DO: 簡潔に、Why を含める
- DON'T: 「修正しました」「Update xxx」のような曖昧な表現

## 例

[examples.md](examples.md)
