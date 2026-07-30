#!/bin/bash
# hook 用の共通関数。source して使う。
#
# コマンド文字列に対する素朴な grep は誤爆する。たとえばコミットメッセージや
# ドキュメントの本文に "gh pr create" と書いただけでブロックされてしまう。
# cmd_invokes は「実際に実行される位置にあるコマンド」だけを判定する。

# heredoc の本文を除去する awk プログラム。
# git commit -F - <<'EOF' ... EOF のような本文はコマンドではないので落とす。
_STRIP_HEREDOC_AWK='
BEGIN { inhd = 0 }
{
  if (inhd) {
    line = $0
    sub(/^[ \t]+/, "", line)
    if (line == marker) inhd = 0
    next
  }
  # <<< (herestring) は本文が同一行なので heredoc として扱わない
  if ($0 !~ /<<</ && match($0, /<<-?[ \t]*['"'"'"]?[A-Za-z_][A-Za-z0-9_]*['"'"'"]?/)) {
    m = substr($0, RSTART, RLENGTH)
    sub(/^<<-?[ \t]*/, "", m)
    gsub(/['"'"'"]/, "", m)
    marker = m
    inhd = 1
    print $0
    next
  }
  print
}
'

# cmd_invokes <コマンド文字列> <ERE パターン>
#
# パターンがコマンドの先頭位置（行頭 / ; / && / || / | / ( / { の直後）に
# 現れる場合だけ真を返す。VAR=1 のような環境変数プレフィックスは読み飛ばす。
#
# 例: cmd_invokes "$CMD" 'gh[[:space:]]+pr[[:space:]]+create'
cmd_invokes() {
  local cmd="$1" pattern="$2"
  printf '%s\n' "$cmd" \
    | awk "$_STRIP_HEREDOC_AWK" \
    | sed -E 's/(\&\&|\|\||\||;|\(|\{|`)/\
/g' \
    | sed -E 's/^[[:space:]]*//' \
    | sed -E 's/^([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)+//' \
    | grep -qE "^${pattern}"
}

# cmd_strip_heredoc <コマンド文字列>
# heredoc 本文を除去した文字列を返す。オプションの有無を見るときに使う。
cmd_strip_heredoc() {
  printf '%s\n' "$1" | awk "$_STRIP_HEREDOC_AWK"
}

# hook の stdin(JSON) から値を取り出す。
# 例: IN=$(cat); CMD=$(hook_field "$IN" '.tool_input.command')
hook_field() {
  printf '%s' "$1" | jq -r "$2 // empty"
}
