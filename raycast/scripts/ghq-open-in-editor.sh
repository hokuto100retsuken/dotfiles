#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title リポジトリを VS Code で開く
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝
# @raycast.packageName ghq
# @raycast.argument1 { "type": "text", "placeholder": "リポジトリ名の一部" }

# Documentation:
# @raycast.description ghq 管理下のリポジトリを部分一致で絞り込み、最初にマッチしたものを VS Code で開く
# @raycast.author hokuto100retsuken

set -euo pipefail

# Raycast はログインシェルを経由しないため Homebrew の PATH を明示的に通す
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

query="$1"

if ! command -v ghq >/dev/null; then
  echo "ghq が見つかりません"
  exit 1
fi

match=$(ghq list | grep -i -- "$query" | head -n 1 || true)

if [[ -z "$match" ]]; then
  echo "該当なし: $query"
  exit 1
fi

open -a "Visual Studio Code" "$(ghq root)/$match"
echo "VS Code で開きました: $match"
