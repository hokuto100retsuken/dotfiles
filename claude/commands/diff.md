現在のブランチの変更内容を日本語で要約する。

## 手順
1. base ブランチを特定する
   - `git symbolic-ref refs/remotes/origin/HEAD` でリモートの HEAD を確認、無ければ master / main の順で探す
2. `git diff <base>...HEAD` と `git log <base>..HEAD --oneline` で変更内容を把握
3. 変更内容を以下の形式で簡潔にまとめる：
   - 何を変えたか（概要1〜2行）
   - 変更したファイルと、それぞれの変更内容（箇条書き）
4. 結果をそのまま表示する

## 注意
- 簡潔に。コードの中身をそのまま貼らない
- 技術的に正確に。推測で補わない
- diff が空なら「差分なし」と伝える

$ARGUMENTS
