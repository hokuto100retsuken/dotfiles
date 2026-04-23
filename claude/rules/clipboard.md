---
description: クリップボードへのコピー方針
globs:
---

- クリップボードへのコピーは、ユーザーが明示的に「コピーして」「クリップボードに入れて」等と頼んだときだけ行う
- 自発的にクリップボードへコピーしない
- macOSでは `pbcopy`、Linuxでは `xclip -selection clipboard` または `xsel --clipboard` を使う
- コピーする内容はMarkdown形式で、前置き不要、本文のみ
- コピー完了したら「クリップボードにコピーしました」と一言伝える
