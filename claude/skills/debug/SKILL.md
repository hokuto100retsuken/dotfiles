---
name: debug
description: colorme-admin / colorme-user 等の Rails プロジェクトのデバッグ支援。エラーログやスタックトレースから原因を特定する。決済/Doorkeeper/Sidekiq を含むコードベース専用。
---

# Debugスキル

colorme-admin / colorme-user 等の Rails アプリケーションのデバッグを支援する。

対象外のプロジェクト（Rails でない、または決済/Doorkeeper/Sidekiq を含まない）では適用せず、汎用的なデバッグに切り替える。

## 入力
- エラーメッセージ、スタックトレース、または再現手順

## 手順
1. エラーの種類を特定（例外クラス、HTTPステータス等）
2. スタックトレースから関連するソースコードを読む
3. 原因を特定し、修正案を提示
4. 必要に応じてテストで再現を確認

## 調査のポイント
- モデルのバリデーションエラー → `app/models/` のバリデーション定義を確認
- N+1クエリ → `includes` / `preload` の不足を確認
- 決済エラー → 該当決済プロバイダのモデルとPerformerを確認
- 認証エラー → Doorkeeper設定とスコープを確認
- ジョブ失敗 → Sidekiqのリトライ設定とエラーハンドリングを確認
