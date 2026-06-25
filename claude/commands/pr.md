現在のブランチからPRを作成する。

## 手順
1. base ブランチを特定する
   - `git symbolic-ref refs/remotes/origin/HEAD` でリモートの HEAD を確認、無ければ master / main の順で探す
2. `git diff <base>...HEAD` と `git log <base>..HEAD` で変更内容を把握
3. ブランチが未 push なら `git push -u origin <branch>` を実施
4. `.github/PULL_REQUEST_TEMPLATE.md` が存在するか確認し、あればテンプレに沿って本文を構築
5. 変更内容から適切なPRタイトルと説明を日本語で作成
6. `gh pr create --draft` でPRを作成（必ず `--draft` を付ける。Ready化はユーザー判断なので `gh pr ready` はしない）
   - タイトル: 変更内容を簡潔に表現（70文字以内）
   - 本文: 目的と変更内容をMarkdownで記述（テンプレがあればそれに従う）
7. PR URLを表示

$ARGUMENTS（任意の追加指示。特定の reviewer / label 等）
