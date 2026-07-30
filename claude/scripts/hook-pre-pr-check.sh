#!/bin/bash
# PreToolUse(Bash) hook: `gh pr create` を捕まえて PR作成前チェックを走らせる。
# 指摘が1件でもあれば exit 2 で作成を止め、内容をモデルに返す。
#
# 回避したいときは、コマンドに SKIP_PRE_PR_CHECK=1 を付けて実行する。

IN=$(cat)
CMD=$(echo "$IN" | jq -r '.tool_input.command // empty')

echo "$CMD" | grep -qE 'gh +pr +create' || exit 0
echo "$CMD" | grep -q 'SKIP_PRE_PR_CHECK=1' && exit 0

CWD=$(echo "$IN" | jq -r '.cwd // empty')
[ -n "$CWD" ] && cd "$CWD" 2>/dev/null

BASE=$(echo "$CMD" | sed -nE 's/.*--base[= ]+"?([^ "]+).*/\1/p')

OUT=$(bash "$(dirname "$0")/pre-pr-check.sh" ${BASE:+--base "$BASE"} 2>&1)

if [ -n "$OUT" ]; then
  {
    echo "$OUT"
    echo
    echo "PR作成を保留しました。上記を修正するか、ユーザーに確認してから再実行してください。"
    echo "確認済みで対応不要と判断した場合のみ、コマンド先頭に SKIP_PRE_PR_CHECK=1 を付けて再実行できます。"
  } >&2
  exit 2
fi

exit 0
