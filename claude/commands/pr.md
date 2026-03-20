現在のブランチからPRを作成する。

## 手順
1. `git diff master...HEAD` と `git log master..HEAD` で変更内容を把握（masterがなければmainを使う）
2. 変更内容から適切なPRタイトルと説明を日本語で作成
3. `gh pr create` でPRを作成
   - タイトル: 変更内容を簡潔に表現（70文字以内）
   - 本文: 目的と変更内容をMarkdownで記述
4. PR URLを表示

$ARGUMENTS
