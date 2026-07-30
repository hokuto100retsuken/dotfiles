#!/bin/bash
# PreToolUse(Bash) hook: PRのReady化を禁止し、PR作成は必ず draft に強制する（pr-style.md）。
#
# 判定は hook-lib.sh の cmd_invokes を使う。コマンドとして実行される位置にある
# ものだけを見るので、コミットメッセージやドキュメント本文に同じ文字列が
# 出てきてもブロックしない。

. "$(dirname "$0")/hook-lib.sh"

IN=$(cat)
CMD=$(hook_field "$IN" '.tool_input.command')
[ -z "$CMD" ] && exit 0

if cmd_invokes "$CMD" 'gh[[:space:]]+pr[[:space:]]+ready'; then
  echo "BLOCKED: PRのReady化はユーザー判断です。gh pr ready は実行しないでください（pr-style.md）" >&2
  exit 2
fi

if cmd_invokes "$CMD" 'gh[[:space:]]+pr[[:space:]]+create'; then
  BODY=$(cmd_strip_heredoc "$CMD")
  if ! echo "$BODY" | grep -qE '(--draft|[[:space:]]-d([[:space:]]|$))'; then
    echo "BLOCKED: PRは必ずドラフトで作成してください。--draft を付けてください（pr-style.md）" >&2
    exit 2
  fi
fi

exit 0
