#!/bin/bash
# SessionStart hook: cwd に対応する handoff.md をセッション冒頭に注入する。
#
# handoff.md は並行セッションがセクションを追記していくため放置すると際限なく育つ
# （実測: colorme で 125KB / 見出し40個）。全文を流すとセッションの先頭で数万トークンを
# 消費するので、新しい方から MAX_LINES 行 / MAX_SECTIONS 見出しまでに切る。
#
# 古い handoff は「前回の続き」として誤読されるので、STALE_DAYS を超えたら本文を出さず
# 存在だけ知らせる。

MAX_LINES=200
MAX_SECTIONS=3
STALE_DAYS=14

IN=$(cat)
D=$(printf '%s' "$IN" | jq -r '.cwd // empty')
[ -z "$D" ] && D="$PWD"

H="$HOME/.claude/projects/$(printf '%s' "$D" | sed 's|[/.]|-|g')/handoff.md"
[ -f "$H" ] || exit 0

# mtime は macOS と Linux で stat のオプションが違う
MTIME=$(stat -f %m "$H" 2>/dev/null || stat -c %Y "$H" 2>/dev/null)
[ -z "$MTIME" ] && exit 0
AGE_DAYS=$(( ( $(date +%s) - MTIME ) / 86400 ))
SAVED=$(date -r "$MTIME" '+%Y-%m-%d' 2>/dev/null || date -d "@$MTIME" '+%Y-%m-%d' 2>/dev/null)

if [ "$AGE_DAYS" -gt "$STALE_DAYS" ]; then
  printf '引き継ぎメモ (handoff.md) は %s / %d日前のもので、古いため本文は読み込んでいません。\n' "$SAVED" "$AGE_DAYS"
  printf '必要なら %s を読んでください。\n' "$H"
  exit 0
fi

TOTAL=$(wc -l < "$H" | tr -d ' ')
BODY=$(awk -v maxs="$MAX_SECTIONS" -v maxl="$MAX_LINES" '
  /^# / { n++; if (n > maxs) exit }
  { print; if (NR >= maxl) exit }
' "$H")
SHOWN=$(printf '%s\n' "$BODY" | wc -l | tr -d ' ')

printf '前回からの引き継ぎ (handoff.md / %s / %d日前):\n\n' "$SAVED" "$AGE_DAYS"
printf '%s\n' "$BODY"

if [ "$SHOWN" -lt "$TOTAL" ]; then
  printf '\n(全 %d 行のうち先頭 %d 行のみ。残りは %s を直接読んでください)\n' "$TOTAL" "$SHOWN" "$H"
fi
