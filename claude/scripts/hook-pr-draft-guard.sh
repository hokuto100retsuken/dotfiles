#!/bin/bash
# PreToolUse(Bash) hook: issue / PR の作成は毎回ユーザーに確認し、PRのReady化を禁止し、
# PR作成は必ず draft に強制する（pr-style.md）。
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

# issue / PR の新規作成は毎回ユーザーに確認する。
#
# 本文を見せずに作られる事故が実際に起きている。deny ではなく ask を返して
# 許可ダイアログを出す。auto mode の分類器が自動承認するのを上書きするため、
# 文章のルールだけでは止まらないこの経路をここで塞ぐ。
for pat in 'gh[[:space:]]+issue[[:space:]]+create' 'gh[[:space:]]+pr[[:space:]]+create'; do
  if cmd_invokes "$CMD" "$pat"; then
    case "$pat" in
      *issue*) what="issue" ;;
      *)       what="PR" ;;
    esac
    jq -nc --arg w "$what" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "ask",
        permissionDecisionReason: ("\($w) の新規作成です。本文をユーザーに見せて承認を得てから実行してください（pr-style.md）")
      }
    }'
    exit 0
  fi
done

exit 0
