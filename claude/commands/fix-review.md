PRのレビューコメントを確認し、指摘内容を修正する。

## 引数
$ARGUMENTS にPR番号を指定する。省略時は現在のブランチのPRを自動検出する。

## 手順
1. PR番号と owner/repo の特定
   - PR 番号: 引数があればそれを使う、なければ `gh pr view --json number -q .number`
   - owner/repo: `gh repo view --json owner,name -q "\(.owner.login)/\(.name)"`
2. レビューコメントの取得
   - `gh api repos/{owner}/{repo}/pulls/{number}/reviews` でレビュー一覧を取得
   - `gh api repos/{owner}/{repo}/pulls/{number}/comments` でインラインコメントを取得
   - `gh pr view {number} --comments` でPR全体のコメントも確認
3. 対応が必要なコメントの整理
   - 未解決の指摘のみリストアップする
     - インラインコメント: `isResolved=false` またはレスポンスがないもの
     - レビュー: `state=CHANGES_REQUESTED` で未対応のもの
   - 各コメントについて、対象ファイル・行・指摘内容をまとめる
   - ユーザーに表示する
4. ユーザーに対応方針を確認
   - すべて対応するか、スキップするものがあるか確認する
5. 修正の実施
   - 指摘内容に基づいてコードを修正する
   - 修正ごとにコミットする（コミットメッセージは指摘内容に対応した内容にする）
6. 結果の報告
   - 何を修正したかを簡潔に報告する
