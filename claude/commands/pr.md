現在のブランチからPRを作成する。

## 手順

### 1. 機械チェック（先に通す）

`bash ~/src/github.com/hokuto100retsuken/dotfiles/claude/scripts/pre-pr-check.sh` を実行する。
指摘が出たら、PR本文を書き始める前に対応する（BLOCK は必須修正、WARN は意図的かどうかユーザーに確認）。

> `gh pr create` 時に hook で同じチェックが走るため、ここを飛ばしても最終的に止まる。

### 2. 差分の把握

- base ブランチを特定（`git symbolic-ref refs/remotes/origin/HEAD` → 無ければ master / main）
- base が master/main 以外なら**依存元PRがある**。そのPR番号とマージ順を控える
- `git diff <base>...HEAD` と `git log <base>..HEAD` で変更内容を把握

### 3. 仕様ソースの収集（レビュー指摘の最頻帯）

差分だけ見て本文を書かない。以下を集めてから書く。

- **issue**: ブランチ名 / コミットメッセージ / 既存PR本文から issue 番号（`#NNNN`・`colorme/xxx#NNNN`）を抽出し、
  `GH_HOST=git.pepabo.com gh issue view <番号> -R colorme/<repo>` で要件を取得
- **仕様書**: `~/src/git.pepabo.com/colorme/trunk` を差分のキーワードで grep し、該当ドキュメントを読む
- **Notion / Slack**: issue 本文・コメント中の Notion / Slack URL を抽出し、
  `notion-fetch` / `slack_read_thread` で内容を取得（どちらも許可済み）

集めたら差分と1対1で突き合わせ、**次の点に齟齬や未確認がないか**検査する：

- 判定条件・状態のマッピングが仕様と一致しているか。全パターンを列挙して、どこにも入らない／どちらにも入りうる状態がないか
- 判定の粒度（ショップ単位 vs 種別単位、アカウント単位 vs 注文単位）
- 「この場合は対象外」と決まった例外が抜けていないか
- 画面文言・メール文面が確定版と一字一句一致しているか。用語が既存の呼称と揃っているか

**齟齬や確信の持てない点があれば、PRを作らずユーザーに選択肢付きで確認する。**

### 4. push

ブランチが未 push なら `git push -u origin <branch>`。

### 5. PR本文の構築

`.github/PULL_REQUEST_TEMPLATE.md` があればそれに従う。テンプレの有無にかかわらず、以下は必ず埋める
（レビュアーからの背景質問を減らすため）：

- **なぜこの対応が必要か** — issue リンク＋一言。「どの入口からのフローの話か」も書く
- **仕様の出どころ** — Notion / Slack / trunk のリンク。合意済みの決定は誰と合意したかも
- **依存PRとマージ順** — base が master 以外の場合は必須
- **レビューポイント** — 判断が分かれた箇所と、そう判断した根拠。仕様に明記がなく自分で決めた点は明示
- **動作確認** — 何をどう確認したか

生成バッジ（Generated with Claude Code 等）は入れない。

### 6. 作成

`gh pr create --draft` で作成する（必ず `--draft`。Ready化はユーザー判断なので `gh pr ready` はしない）。

- タイトル: 変更内容を簡潔に（70文字以内）
- 本文: 日本語 Markdown

### 7. PR URL を表示

$ARGUMENTS（任意の追加指示。特定の reviewer / label 等）
