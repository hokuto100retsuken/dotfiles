# Claude Code 設定

Claude Code 関連の設定を管理します。`scripts/setup-dotfiles.sh` により `~/.claude/` 配下にシンボリックリンクされます。

## 構造

```
claude/
├── CLAUDE.md   # グローバル設定（rulesに分割済みなので最小）
├── rules/      # 恒常ルール（毎セッション自動ロード）
├── skills/     # 明示的に呼び出すワークフロー
├── commands/   # スラッシュコマンド
├── agents/     # サブエージェント定義（モデル・ツールを固定する）
├── workflows/  # 並列オーケストレーション（決定論的な多段処理）
└── scripts/    # hook 本体（PR作成前チェック等）
```

方針は [Zenn: Claude Code の rules / skills を分割してコンテキストを83%削減した話](https://zenn.dev/pepabo/articles/claude-code-rules-skills-split) を参考。

職場固有の skills / commands は別リポジトリ（dotfiles-pepabo 等）に分離し、scripts/setup-dotfiles.sh は per-item symlink で両方の内容を `~/.claude/skills` / `~/.claude/commands` に合流させる構成。

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
| failure-learning | 失敗の記録と汎用ルールへの昇格 |
| git-hosting | リモートは git.pepabo.com（dotfiles-pepabo 由来） |
| model-roles | Opus / Sonnet の役割分担 |
| no-external-upload | 外部アップロードの禁止 |
| pr-style | PR本文の方針 |
| response-style | 回答スタイル |
| self-review | 仕様ズレ・既存破壊を先回りで指摘する |
| small-commits | コミット粒度 |
| use-templates | テンプレートの尊重 |

## Skills（明示的に呼び出し）

| スキル | 用途 |
|--------|------|
| code-style-quality | コードスタイル・品質ルール |
| commit-message | 日本語コミットメッセージ生成 |
| dev | 大きめの開発タスクをパイプラインで進める |
| dotfiles-expert | dotfiles リポジトリの構造・規約理解 |
| empirical-prompt-tuning | プロンプトを反復改善する手法 |
| explain | コードの処理フロー解説 |

職場固有の skills（debug / euc-jp-workflow / search-repos / status / work-log 等）は dotfiles-pepabo 側にあり、`~/.claude/skills` で合流する。

## Commands

| コマンド | 用途 |
|----------|------|
| /copy | 調査・ドキュメント作成してクリップボードにコピー |
| /diff | ブランチの変更内容を日本語で要約 |
| /fix-review | PRのレビューコメント修正 |
| /handoff | セッションの引き継ぎメモ保存 |
| /kickoff | タスク開始時のゴール明文化（dotfiles-pepabo 由来） |
| /pr | 現在のブランチからPR作成 |
| /review | ブランチの変更内容をレビュー |
| /review-ai-worker | @ai-worker にPRレビューを依頼（dotfiles-pepabo 由来） |

## Agents（サブエージェント）

`model-roles.md` は「調査は Sonnet、思考は Opus」と定めているが、文章のままではモデル選択が毎回の判断に委ねられる。ここで**モデルとツール権限を定義として固定**する。

| エージェント | モデル | 用途 |
|--------------|--------|------|
| researcher | sonnet | 複数リポジトリ・複数ディレクトリの横断調査。読み取り専用 |
| spec-checker | opus | 実装を trunk の仕様書と issue の合意事項に照らして突き合わせる |

## Workflows（並列オーケストレーション）

決定論的な多段処理。`agent()` を並列に起動し、結果を統合する。**エージェントを多数起動するためトークン消費が大きく、明示的に指示したときだけ動く**。

| ワークフロー | 用途 |
|--------------|------|
| investigate-repos | リポジトリごとに researcher を並列起動して横断調査 → 統合 |
| review-branch | 差分を観点別に並列レビュー → 各指摘を別エージェントが反証 → 生存分のみ返す |

## 並列実行の使い分け

「一気にやる」には性質の違う4つの手段がある。用途を間違えると遅くなるだけなので使い分ける。

| やりたいこと | 手段 | 設定 |
|--------------|------|------|
| 長いコマンドを待たない | Bash のバックグラウンド実行。終了時に通知が来る | 不要 |
| 独立した調査を同時に | サブエージェントを同一メッセージ内で複数起動 | agents/ |
| 範囲が読めない横断調査 | `investigate-repos` ワークフロー | workflows/ |
| 複数の実装を同時に | git worktree で隔離してから並列実装。同じファイルを触っても衝突しない | 不要 |
| 毎回同じ手順を回す | ワークフロースクリプト。手順を飛ばせなくなる | workflows/ |

軽い読み取り・単発調査でサブエージェントを起動しないこと（起動ごとにフルコンテキストを読み直すためトークンを大きく消費する）。`model-roles.md` と `basics.md` の方針。
