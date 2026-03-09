---
name: commit-message
description: git diffを分析して日本語で簡潔なコミットメッセージを生成する。コミット、コミットログ、変更内容のまとめを依頼された時に使用。Whyを重視する。
---

# コミットメッセージ生成

## 形式

```
<種類>(<スコープ>): <簡潔な説明>

<Why（変更理由）>
```

## ルール

- **日本語**、1行目 50 文字以内
- **Why を書く**: What より Why を重視
- **命令形**: 「追加する」 not 「追加した」

## 種類

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
