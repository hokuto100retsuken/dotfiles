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

# バックグラウンドで実行中のもの（bash / subagent）をトランスクリプトから復元する。
# 開始: toolUseResult.backgroundTaskId（bash） / status=="async_launched"（subagent）
# 完了: queue-operation の <task-notification> に載る <task-id>
# 実行中 = 開始済み − 完了済み。1行目に件数、以降1件1行（TSV: tree/kind/desc/経過）。
bg=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  bg=$(grep -E '"run_in_background":true|"backgroundTaskId"|"async_launched"|"type":"queue-operation"' "$transcript" 2>/dev/null \
    | jq -r -s '
      # 全角は2列、省略記号(U+2026)は1列として数える
      def dispwidth: [explode[] | if . > 4351 and . != 8230 then 2 else 1 end] | add // 0;
      # 省略記号の1列分を残して切るので、結果は必ず $w 列以内に収まる
      def trunc($w): if dispwidth <= $w then .
        else (reduce (explode[]) as $c ({acc: [], w: 0};
                (if $c > 4351 then 2 else 1 end) as $cw
                | if .w + $cw > ($w - 1) then . else {acc: (.acc + [$c]), w: (.w + $cw)} end)
              | .acc | implode) + "…"
        end;
      def pad($w): . + (" " * (($w - dispwidth) | if . < 0 then 0 else . end));
      def elapsed: (. / 60 | floor) as $m | (. % 60 | floor) as $s
        | if . < 60 then "\(. | floor)s"
          elif . < 3600 then "\($m)m\($s)s"
          else "\(($m / 60) | floor)h\(($m % 60) | tostring | if length < 2 then "0" + . else . end)m" end;

      ([.[] | select(.type == "assistant") | .message.content[]? | select(.type == "tool_use")
        | {key: .id, value: (.input.description // ((.input.command // "") | trunc(24)))}] | from_entries) as $desc
      | ([.[] | select(.type == "queue-operation") | (.content // "")
          | capture("<task-id>(?<id>[^<]+)</task-id>").id] | unique) as $done
      | [.[] | select(.type == "user" and (.toolUseResult | type) == "object")
          | . as $r
          | (now - ($r.timestamp | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601)) as $age
          | if $r.toolUseResult.backgroundTaskId then
              {kind: "bash", id: $r.toolUseResult.backgroundTaskId, age: $age,
               desc: ($desc[($r.message.content // []) | map(select(.type == "tool_result").tool_use_id) | first // ""] // "command")}
            elif $r.toolUseResult.status == "async_launched" then
              {kind: "agent", id: $r.toolUseResult.agentId, age: $age,
               desc: ($r.toolUseResult.description // "agent")}
            else empty end]
      | map(select((.id | IN($done[])) | not) | select(.age < 86400))
      | group_by(.id) | map(last) | sort_by(-.age)
      | .[0:5] as $shown | (length - ($shown | length)) as $rest
      | if length == 0 then empty
        else
          "\(length)",
          ($shown | to_entries[]
            | (if .key == (($shown | length) - 1) and $rest == 0 then "└" else "├" end) as $tree
            | "\($tree)\t\(.value.kind | pad(5))\t\(.value.desc | trunc(26) | pad(26))\t\(.value.age | elapsed)"),
          (if $rest > 0 then "└\t     \t他 \($rest) 件\t" else empty end)
        end
    ' 2>/dev/null)
fi

# 色は fish のプロンプトと同じ Carbonfox 風（アイコンは Nerd Font）
RESET='\033[0m'
BOLD='\033[1m'
BLUE='\033[38;2;120;169;255m'     # #78a9ff ディレクトリ
TEAL='\033[38;2;8;189;186m'       # #08bdba ブランチ
MAUVE='\033[38;2;190;149;255m'    # #be95ff タイトル
LAVENDER='\033[38;2;200;165;255m' # #c8a5ff モデル
PEACH='\033[38;2;255;192;185m'    # #ffc0b9 実行中の件数
SKY='\033[38;2;51;177;255m'       # #33b1ff 実行中の種類
GRAY='\033[38;2;141;142;143m'     # #8d8e8f 区切り・補足

parts=()
[ -n "$repo" ] && parts+=("$(printf "${BLUE}\uf07b %s${RESET}" "$repo")")
[ -n "$branch" ] && parts+=("$(printf "${BOLD}${TEAL}\ue0a0 %s${RESET}" "$branch")")
[ -n "$model" ] && parts+=("$(printf "${LAVENDER}\uf2db %s${RESET}" "$model")")

if [ ${#parts[@]} -eq 0 ] && [ -z "$title" ] && [ -z "$bg" ]; then
  exit 0
fi

# join with separator
result=""
for i in "${!parts[@]}"; do
  if [ $i -eq 0 ]; then
    result="${parts[$i]}"
  else
    result="$result $(printf "${GRAY}·${RESET}") ${parts[$i]}"
  fi
done

[ -n "$result" ] && printf "%b\n" "$result"

# 2行目: セッションのタイトル
[ -n "$title" ] && printf "%b\n" "$(printf "${GRAY}╰─${RESET} ${MAUVE}%s${RESET}" "$title")"

# 3行目以降: バックグラウンドで実行中のもの（件数 + 1件1行）
if [ -n "$bg" ]; then
  printf "${PEACH}⏳ %s running${RESET}\n" "$(printf '%s\n' "$bg" | head -n 1)"
  printf '%s\n' "$bg" | tail -n +2 | while IFS=$'\t' read -r tree kind desc age; do
    printf "  ${GRAY}%s${RESET} ${SKY}%s${RESET} %s ${GRAY}%s${RESET}\n" "$tree" "$kind" "$desc" "$age"
  done
fi

exit 0
