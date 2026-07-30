#!/usr/bin/env bash
input=$(cat)

repo=$(echo "$input" | jq -r '.workspace.repo | if . then .name else empty end')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')

# git ブランチ名を取得（repo がある場合のみ）
branch=""
if [ -n "$cwd" ] && [ -d "$cwd/.git" ] || ([ -n "$cwd" ] && git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1); then
  branch=$(git --git-dir="$(git -C "$cwd" rev-parse --git-dir 2>/dev/null)" symbolic-ref --short HEAD 2>/dev/null)
fi

model=$(echo "$input" | jq -r '.model.display_name // empty')

# セッションの AI 生成タイトル（今何を解決しようとしているか）をトランスクリプトから取得
title=""
transcript=$(echo "$input" | jq -r '.transcript_path // empty')
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  title=$(grep '"type":"ai-title"' "$transcript" 2>/dev/null | tail -n 1 | jq -r '.aiTitle // empty')
fi

# ANSI colors
RESET='\033[0m'
BOLD='\033[1m'
CYAN='\033[36m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
DIM='\033[2m'

parts=()
[ -n "$repo" ] && parts+=("$(printf "${CYAN}%s${RESET}" "$repo")")
[ -n "$branch" ] && parts+=("$(printf "${BOLD}${YELLOW}%s${RESET}" "$branch")")
[ -n "$model" ] && parts+=("$(printf "${DIM}%s${RESET}" "$model")")

if [ ${#parts[@]} -eq 0 ] && [ -z "$title" ]; then
  exit 0
fi

# join with separator
result=""
for i in "${!parts[@]}"; do
  if [ $i -eq 0 ]; then
    result="${parts[$i]}"
  else
    result="$result $(printf "${DIM}|${RESET}") ${parts[$i]}"
  fi
done

[ -n "$result" ] && printf "%b\n" "$result"

# 2行目: セッションのタイトル
[ -n "$title" ] && printf "%b\n" "$(printf "${DIM}▸${RESET} ${MAGENTA}%s${RESET}" "$title")"

exit 0
