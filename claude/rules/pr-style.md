- **issue / PR を作る前に必ずユーザーに確認する。** タイトルと本文の全文を見せ、
  承認を得てから `gh issue create` / `gh pr create` を実行する。
  「作っておきますね」で勝手に作らない。**実際に無断で作られた事故があるため、
  PreToolUse hook（`hook-pr-draft-guard.sh`）でも許可ダイアログを出すようにしてある**
- PR本文の末尾に「Generated with Claude Code」等の生成バッジを入れない
- PRは必ずドラフトで作成する（`gh pr create --draft`）。Ready化はユーザーが判断するので、こちらで `gh pr ready` しない
- issue / PR の参照はフルURLで書く。`#NNNN` や `repo#NNNN` の短縮記法は使わない。素の `#NNNN` は「今いるリポジトリ」の番号に解決されるため、別リポジトリを指すつもりでも無関係な issue / PR に誤リンクする
- 別リポジトリの issue を `closes` で紐づけるときもフルURL。ただし cross-repo はマージ時に自動 close されないので、close は手動で行う
