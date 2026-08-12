#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title 現在ブランチの PR を開く
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔀
# @raycast.packageName ghq
# @raycast.argument1 { "type": "text", "placeholder": "リポジトリ名の一部" }

# Documentation:
# @raycast.description ghq 管理下のリポジトリを部分一致で絞り込み、そこでチェックアウト中のブランチに対応する PR をブラウザで開く
# @raycast.author hokuto100retsuken

set -euo pipefail

# Raycast はログインシェルを経由しないため Homebrew の PATH を明示的に通す
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

query="$1"

for cmd in ghq gh; do
  if ! command -v "$cmd" >/dev/null; then
    echo "$cmd が見つかりません"
    exit 1
  fi
done

match=$(ghq list | grep -i -- "$query" | head -n 1 || true)

if [[ -z "$match" ]]; then
  echo "該当なし: $query"
  exit 1
fi

dir="$(ghq root)/$match"
branch=$(git -C "$dir" branch --show-current)

if ! (cd "$dir" && gh pr view --web >/dev/null 2>&1); then
  echo "PR が見つかりません: $match ($branch)"
  exit 1
fi

echo "PR を開きました: $match ($branch)"
