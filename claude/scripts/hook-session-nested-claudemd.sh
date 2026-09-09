#!/bin/bash
# SessionStart hook: 複数リポジトリの親ディレクトリで起動したとき、配下の CLAUDE.md の
# 在り処を知らせる。
#
# cwd 自身の CLAUDE.md はハーネスが読むが、配下リポジトリのものは自動では読まれない。
# colorme のように 30 リポジトリの親で起動する運用だと、リポジトリ固有の規約
# （実測 14ファイル・1877行）が読まれないまま作業が進む。

IN=$(cat)
D=$(printf '%s' "$IN" | jq -r '.cwd // empty')
[ -z "$D" ] && D="$PWD"

# cwd 自身がリポジトリなら何もしない
[ -f "$D/CLAUDE.md" ] && exit 0

FOUND=$(for d in "$D"/*/; do
  [ -f "$d/CLAUDE.md" ] && basename "$d"
done)
[ -z "$FOUND" ] && exit 0
[ "$(printf '%s\n' "$FOUND" | wc -l | tr -d ' ')" -lt 2 ] && exit 0

printf '配下リポジトリの CLAUDE.md（cwd が親なので自動では読まれない）:\n'
printf '%s\n' "$FOUND" | tr '\n' ' '
printf '\n作業対象のリポジトリが決まったら %s/<repo>/CLAUDE.md を読んでから着手すること。\n' "$D"
