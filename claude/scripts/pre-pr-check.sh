#!/bin/bash
# PR作成前の機械チェック。
# 過去に実際レビューで指摘された項目のうち、機械的に判定できるものだけを見る。
#
# 使い方:
#   pre-pr-check.sh [--base <branch>]
#
# 終了コード:
#   0 = 問題なし（WARN はあるかもしれない）
#   1 = BLOCK 該当あり
#
# エスケープハッチ: SKIP_PRE_PR_CHECK=1 を立てると即 exit 0

set -uo pipefail

[ "${SKIP_PRE_PR_CHECK:-}" = "1" ] && exit 0

BASE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --base) BASE="${2:-}"; shift 2 ;;
    --base=*) BASE="${1#--base=}"; shift ;;
    *) shift ;;
  esac
done

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

BLOCKS=()
WARNS=()
block() { BLOCKS+=("$1"); }
warn()  { WARNS+=("$1"); }

# 指定エンコーディングとして復号できないときだけ真を返す。
# macOS の iconv は変換を全て終えたあとでも "Inappropriate ioctl for device" で
# exit 1 を返すことがあり、終了コードで判定すると正常な UTF-8 ファイルまで
# 不正バイト列と誤検出する。そのため stderr のメッセージで判定する。
decode_error() {
  iconv -f "$1" -t UTF-8 "$2" 2>&1 >/dev/null |
    grep -qiE "illegal input sequence|illegal byte sequence|cannot convert|incomplete character"
}

# ---- base ブランチの特定 ----
if [ -z "$BASE" ]; then
  BASE=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
  [ -z "$BASE" ] && for b in master main; do
    git show-ref --verify --quiet "refs/remotes/origin/$b" && { BASE="$b"; break; }
  done
fi
[ -z "$BASE" ] && exit 0

BASE_REF="origin/$BASE"
git show-ref --verify --quiet "refs/remotes/$BASE_REF" || BASE_REF="$BASE"
MERGE_BASE=$(git merge-base HEAD "$BASE_REF" 2>/dev/null) || exit 0

CHANGED=$(git diff --name-only --diff-filter=d "$MERGE_BASE"...HEAD 2>/dev/null)
[ -z "$CHANGED" ] && exit 0
ADDED_LINES=$(git diff "$MERGE_BASE"...HEAD -- $(echo "$CHANGED" | tr '\n' ' ') 2>/dev/null | grep '^+' | grep -v '^+++')

# ============================================================
# 1. 文字化け / エンコーディング事故（BLOCK）
#    実績: colorme-admin#20783, #20641 で PHPDoc が文字化けして指摘
# ============================================================
if command -v nkf >/dev/null 2>&1; then
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    case "$f" in *.png|*.jpg|*.jpeg|*.gif|*.pdf|*.ico|*.woff*|*.zip) continue ;; esac

    # U+FFFD（置換文字）が入っていたら確実に事故
    if grep -q $'\xef\xbf\xbd' "$f" 2>/dev/null; then
      block "文字化け: $f に置換文字(U+FFFD)が含まれています"
      continue
    fi

    new_enc=$(nkf --guess "$f" 2>/dev/null | awk '{print $1}')
    old_enc=$(git show "$MERGE_BASE:$f" 2>/dev/null | nkf --guess 2>/dev/null | awk '{print $1}')

    # 元ファイルのエンコーディングが変わっていたら事故（EUC-JP を UTF-8 で保存した等）
    if [ -n "$old_enc" ] && [ -n "$new_enc" ] && [ "$old_enc" != "$new_enc" ]; then
      case "$old_enc/$new_enc" in
        # 日本語がない状態から日本語が入った場合は ASCII→ が正常に起きる
        ASCII/*) : ;;
        */ASCII) : ;;
        BINARY/*|*/BINARY) : ;;
        *) block "エンコーディング変化: $f が $old_enc → $new_enc に変わっています（元に戻すか意図を確認）" ;;
      esac
    fi

    # 宣言されたエンコーディングとして復号できるか
    case "$new_enc" in
      EUC-JP)    decode_error EUC-JP    "$f" && block "不正バイト列: $f は EUC-JP として解釈できません" ;;
      Shift_JIS) decode_error SHIFT_JIS "$f" && block "不正バイト列: $f は Shift_JIS として解釈できません" ;;
      UTF-8)     decode_error UTF-8     "$f" && block "不正バイト列: $f は UTF-8 として解釈できません" ;;
    esac
  done <<< "$CHANGED"
fi

# ============================================================
# 2. デバッグコードの残骸（BLOCK）
# ============================================================
DEBUG_HITS=$(echo "$ADDED_LINES" | grep -nE '(binding\.pry|binding\.irb|byebug|var_dump\(|[^a-zA-Z_]dd\(|print_r\(|console\.log\(|debugger;|Rails\.logger\.debug.*XXX)' | head -10)
if [ -n "$DEBUG_HITS" ]; then
  block "デバッグコードが残っています:
$(echo "$DEBUG_HITS" | sed 's/^/    /')"
fi

# ============================================================
# 3. TODO / FIXME の残骸（WARN）
#    実績: colorme-admin#20783「TODOコメントが付いたままなので消して」
# ============================================================
TODO_HITS=$(echo "$ADDED_LINES" | grep -E '(TODO|FIXME|XXX:)' | head -10)
if [ -n "$TODO_HITS" ]; then
  warn "TODO/FIXME を追加しています。意図的か、消し忘れかを確認:
$(echo "$TODO_HITS" | sed 's/^/    /')"
fi

# ============================================================
# 4. base ブランチから behind（依存元PRの取り込み漏れ）
#    実績: colorme-api#10156「scope :active が依存元PR の途中版のまま」
# ============================================================
BEHIND=$(git rev-list --count "HEAD..$BASE_REF" 2>/dev/null || echo 0)
if [ "$BEHIND" -gt 0 ]; then
  case "$BASE" in
    master|main)
      warn "base($BASE) から $BEHIND コミット behind です" ;;
    *)
      block "依存元ブランチ $BASE から $BEHIND コミット behind です。最新差分を取り込んでから作成してください（git merge $BASE_REF）" ;;
  esac
fi

# ============================================================
# 5. データ更新SQL のトランザクション / 行数検証（WARN）
#    実績: qrunner#2569
# ============================================================
SQL_FILES=$(echo "$CHANGED" | grep -E '\.sql$' || true)
if [ -n "$SQL_FILES" ]; then
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    if grep -qiE '^[[:space:]]*(UPDATE|DELETE|INSERT)' "$f"; then
      grep -qiE '(BEGIN|START TRANSACTION)' "$f" || warn "SQL: $f が UPDATE/DELETE を含みますがトランザクションで囲まれていません"
      grep -qiE 'ROW_COUNT\(\)' "$f" || warn "SQL: $f に更新行数の検証（ROW_COUNT()）がありません"
    fi
  done <<< "$SQL_FILES"
fi

# ============================================================
# 6. 実装だけ変えてテストがない（WARN）
# ============================================================
HAS_IMPL=$(echo "$CHANGED" | grep -E '^(app|lib|public/app|common)/' | grep -vE '\.(erb|tpl|html|css|scss|yml|yaml|json|md)$' || true)
HAS_TEST=$(echo "$CHANGED" | grep -E '^(spec|test|tests)/' || true)
if [ -n "$HAS_IMPL" ] && [ -z "$HAS_TEST" ]; then
  warn "実装ファイルを変更していますがテストの差分がありません"
fi

# ============================================================
# 7. 対称性（WARN）
#    実績: colorme-api#10161「カタログの変更申請のみにテストを足してる理由は？」
#    同型ファイルの片側だけ触っていないかを対語辞書で検出
# ============================================================
PAIRS="catalog:banner epsilon:pg_mulpay submission:suspension basic:brand create:update top:list credit:conveni"
while IFS= read -r f; do
  for pair in $PAIRS; do
    a="${pair%%:*}"; b="${pair##*:}"
    for d in "$a:$b" "$b:$a"; do
      from="${d%%:*}"; to="${d##*:}"
      case "$f" in
        *"$from"*)
          counterpart="${f//$from/$to}"
          if [ -f "$counterpart" ] && ! echo "$CHANGED" | grep -qxF "$counterpart"; then
            warn "対称性: $f を変更していますが、対になる $counterpart は未変更です（意図的か確認）"
          fi
          ;;
      esac
    done
  done
done <<< "$CHANGED"

# ============================================================
# 8. lint（BLOCK）— 変更ファイルのみ
#    ローカルに実行環境がない場合（Docker前提のプロジェクト等）は黙ってスキップする。
#    CI の reviewdog が担保しているので、ここで止める必要はない。
# ============================================================
RB_FILES=$(echo "$CHANGED" | grep -E '\.rb$' | while IFS= read -r f; do [ -f "$f" ] && echo "$f"; done)
if [ -n "$RB_FILES" ] && [ -f .rubocop.yml ]; then
  RUBOCOP=""
  if command -v bundle >/dev/null 2>&1 && bundle exec rubocop --version >/dev/null 2>&1; then
    RUBOCOP="bundle exec rubocop"
  elif command -v rubocop >/dev/null 2>&1; then
    RUBOCOP="rubocop"
  fi
  if [ -n "$RUBOCOP" ]; then
    OUT=$($RUBOCOP --force-exclusion --format simple $RB_FILES 2>&1)
    echo "$OUT" | grep -qE 'no offenses' || \
      block "rubocop に指摘があります:
$(echo "$OUT" | tail -20 | sed 's/^/    /')"
  fi
fi

PHP_FILES=$(echo "$CHANGED" | grep -E '\.php$' | while IFS= read -r f; do [ -f "$f" ] && echo "$f"; done)
if [ -n "$PHP_FILES" ] && { [ -f phpcs.xml ] || [ -f phpcs.xml.dist ] || [ -f .phpcs.xml ]; }; then
  PHPCS=""
  [ -x vendor/bin/phpcs ] && PHPCS=vendor/bin/phpcs
  [ -z "$PHPCS" ] && command -v phpcs >/dev/null 2>&1 && PHPCS=phpcs
  if [ -n "$PHPCS" ] && $PHPCS --version >/dev/null 2>&1; then
    OUT=$($PHPCS --report=summary $PHP_FILES 2>&1)
    echo "$OUT" | grep -qiE '\b(ERROR|WARNING)S?\b' && \
      block "phpcs に指摘があります:
$(echo "$OUT" | tail -20 | sed 's/^/    /')"
  fi
fi

# ============================================================
# 9. JSON.parse の rescue 漏れ（WARN）— 変更ファイルのみ
#    実績: colorme-api#9820 #9586 #9434「JSON.parse に rescue なし。
#          他のFincodeクラスは JSON::ParserError を明示rescueしている」
#    同リポジトリの既存クラスと揃っていないことが指摘の本質なので、
#    「同一ファイル内に rescue が無い」ものだけを見る。
#    ast-grep が無い環境では黙ってスキップする。
# ============================================================
if command -v ast-grep >/dev/null 2>&1; then
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    case "$f" in *.rb) ;; *) continue ;; esac
    [ -f "$f" ] || continue
    ast-grep --lang ruby --pattern 'JSON.parse($$$A)' "$f" 2>/dev/null | grep -q . || continue
    grep -qE 'rescue[^#]*JSON::ParserError' "$f" && continue
    warn "$f は JSON.parse を呼んでいますが JSON::ParserError を rescue していません（同種の既存クラスの rescue と揃えてください）"
  done <<< "$CHANGED"
fi

# ============================================================
# 10. nil 危険な .first チェーン（WARN）— 追加行のみ
#     実績: colorme-api#10200「active.first が nil で NoMethodError → 500」
#           colorme-api#10028「レコードがないのは基本ないので例外にしておくのが良さげ」
#     0件時に nil になる .first に直接メソッドを呼んでいる追加行を見る。
# ============================================================
while IFS= read -r f; do
  [ -z "$f" ] && continue
  case "$f" in *.rb) ;; *) continue ;; esac
  HITS=$(git diff "$MERGE_BASE"...HEAD -- "$f" 2>/dev/null |
    grep '^+' | grep -v '^+++' |
    grep -E '\.first\.[a-z_]' | head -3)
  [ -z "$HITS" ] && continue
  warn "nil 危険: $f の追加行で .first の戻り値に直接メソッドを呼んでいます（0件なら NoMethodError→500）。
    「あり得ない」なら握りつぶさず例外を投げる方針か確認してください:
$(echo "$HITS" | sed 's/^/      /')"
done <<< "$CHANGED"

# ============================================================
# 11. 内部エラー情報の外部出力（WARN）— 変更ファイルのみ
#     実績: colorme-api#9688「エラー通知メールに @error_message を素通し」
#     購入者/オーナー向けの画面・メール文面に外部APIの生メッセージを出さない。
#
#     対象は ERB (.erb) のみ。colorme-admin / colorme-user の PHP テンプレート
#     (.tpl) は出力構文が異なるため未対応（Smarty の {$var} 等を未確認）。
# ============================================================
while IFS= read -r f; do
  [ -z "$f" ] && continue
  case "$f" in
    *.erb) ;;
    *) continue ;;
  esac
  [ -f "$f" ] || continue
  HITS=$(grep -nE '<%=[^%]*(@error_message|\.message)' "$f" 2>/dev/null | head -3)
  [ -z "$HITS" ] && continue
  warn "情報漏洩の懸念: $f がエラーメッセージをそのまま出力しています（外部APIの生メッセージを購入者/オーナーに見せていないか確認）:
$(echo "$HITS" | sed 's/^/      /')"
done <<< "$CHANGED"

# ============================================================
# 12. brakeman（WARN）— 変更した実装ファイルのみ
#     Gemfile に入っているのに一度も走っていなかった。決済コードを多く扱う
#     ため、外部入力の取り回しは機械で見ておく。
#     --only-files で「変更したファイルに関する警告」だけに絞り、
#     -w2 で信頼度が中以上のものだけを見る（誤検出でノイズにしない）。
#     ローカルに ruby 実行環境が無い場合は黙ってスキップする（rubocop と同様）。
# ============================================================
RB_IMPL=$(echo "$CHANGED" | grep -E '^(app|lib)/.*\.rb$' | while IFS= read -r f; do [ -f "$f" ] && echo "$f"; done)
if [ -n "$RB_IMPL" ] && [ -f config/application.rb ]; then
  BRAKEMAN=""
  if command -v bundle >/dev/null 2>&1 && bundle exec brakeman --version >/dev/null 2>&1; then
    BRAKEMAN="bundle exec brakeman"
  elif command -v brakeman >/dev/null 2>&1; then
    BRAKEMAN="brakeman"
  fi
  if [ -n "$BRAKEMAN" ]; then
    ONLY=$(echo "$RB_IMPL" | paste -sd, -)
    OUT=$($BRAKEMAN --quiet --no-progress --no-pager -w2 -f plain --only-files "$ONLY" 2>/dev/null)
    if echo "$OUT" | grep -qE '^(Confidence|[0-9]+ security warning)'; then
      echo "$OUT" | grep -q '^0 security warnings' || \
        warn "brakeman が変更ファイルに警告を出しています（誤検出の可能性もあるので中身を確認してください）:
$(echo "$OUT" | grep -A4 '^Confidence' | head -20 | sed 's/^/      /')"
    fi
  fi
fi

# ============================================================
# 13. bundler-audit（WARN）— Gemfile.lock を変更したときだけ
#     既知の脆弱性を持つ gem を持ち込んでいないか。
#     advisory DB の更新（--update）は行わない。ネットワークに依存させると
#     PR作成が不安定になるため、ローカルDBが無い場合はスキップする。
# ============================================================
if echo "$CHANGED" | grep -qx 'Gemfile.lock'; then
  AUDIT=""
  if command -v bundle >/dev/null 2>&1 && bundle exec bundle-audit version >/dev/null 2>&1; then
    AUDIT="bundle exec bundle-audit"
  elif command -v bundle-audit >/dev/null 2>&1; then
    AUDIT="bundle-audit"
  fi
  if [ -n "$AUDIT" ]; then
    OUT=$($AUDIT check 2>/dev/null)
    echo "$OUT" | grep -q 'No vulnerabilities found' || {
      [ -n "$OUT" ] && warn "bundler-audit が脆弱性を報告しています:
$(echo "$OUT" | grep -E '^(Name|Version|Advisory|Criticality|Title):' | head -16 | sed 's/^/      /')"
    }
  fi
fi

# ============================================================
# 14. 差分で新登場する識別子（WARN）
#     実績: colorme-api#10219「通報という単語は聞き慣れない」
#           #9512「konbini で統一したいです」#9440「use_money という用語は」
#           #10171「ちょっと略しすぎな気もしている」
#     既存コードベースに一度も現れない語は、既存の呼称とずれている可能性がある。
#     日本語（漢字語）も対象にしたかったが、混在エンコーディングのリポジトリで
#     バイト単位マッチが安定しなかったため識別子だけを見る。
#     日本語の用語ずれは rules/self-review.md の「用語を発明しない」で人が見る。
# ============================================================
VOCAB_PATHS=""
for p in app lib config spec; do
  git cat-file -e "$MERGE_BASE:$p" 2>/dev/null && VOCAB_PATHS="$VOCAB_PATHS $p"
done
if [ -n "$VOCAB_PATHS" ]; then
  KNOWN=$(git archive "$MERGE_BASE" $VOCAB_PATHS 2>/dev/null | tar -xO -f - 2>/dev/null |
    LC_ALL=C grep -aoE '[a-z][a-z0-9_]{3,}' | sort -u)
  NOVEL=$(git diff "$MERGE_BASE"...HEAD -- $VOCAB_PATHS 2>/dev/null |
    LC_ALL=C grep -a '^+' | LC_ALL=C grep -av '^+++' |
    LC_ALL=C grep -aoE '[a-z][a-z0-9_]{3,}' | sort -u |
    comm -23 - <(echo "$KNOWN"))
  COUNT=$(echo "$NOVEL" | grep -c . )
  if [ "$COUNT" -gt 0 ]; then
    warn "この差分で初めて登場する識別子が ${COUNT} 件あります。既存の呼称・綴りと揃っているか確認してください
（新機能なら新語が出るのは正常です。既存語の言い換えになっていないかだけ見てください）:
$(echo "$NOVEL" | head -15 | sed 's/^/      /')$([ "$COUNT" -gt 15 ] && echo "
      ... 他 $((COUNT - 15)) 件")"
  fi
fi

# ============================================================
# 出力
# ============================================================
{
  if [ ${#WARNS[@]} -gt 0 ]; then
    echo "⚠️  PR作成前チェック: 確認事項 ${#WARNS[@]} 件"
    for w in "${WARNS[@]}"; do echo "  - $w"; done
    echo
  fi
  if [ ${#BLOCKS[@]} -gt 0 ]; then
    echo "🚫 PR作成前チェック: 修正が必要な項目 ${#BLOCKS[@]} 件"
    for b in "${BLOCKS[@]}"; do echo "  - $b"; done
    echo
    echo "修正してから再実行してください。誤検出の場合のみ SKIP_PRE_PR_CHECK=1 を付けて回避できます。"
  fi
} >&2

[ ${#BLOCKS[@]} -gt 0 ] && exit 1
exit 0
