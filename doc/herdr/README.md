# herdr 使いこなしガイド

[herdr](https://herdr.dev) は AI コーディングエージェント向けのターミナル多重化ツール。
設定は `config/herdr/config.toml`（`~/.config/herdr/config.toml` に symlink）。

## 用語と画面の構造

```
session（永続。ターミナルを閉じても生き残る）
└─ space = workspace（作業単位。1リポジトリ / 1ブランチが目安）
   └─ tab
      └─ pane（ここにシェルやエージェントが入る）
```

サイドバーは上下2段に分かれている。**この2つが herdr の中心**。

| 段 | 名前 | 何が並ぶか |
|:---|:---|:---|
| 上段 | **spaces** | space 一覧。ブランチ名と git の変更状況が付く |
| 下段 | **agents** | 検出されたエージェント一覧。space をまたいで横断表示される |

spaces は「場所」、agents は「今動いているもの」を見る場所。
別の space で回しているエージェントが詰まったら、下段に出るので気付ける。

## prefix は `Ctrl+x`

既定の `Ctrl+b` から変更している。理由:

- **prefix キーはペイン内のアプリに一切届かない**（herdr が食う）
- `Ctrl+b` は fish の `switch_branch`、nvim の `<C-b>`、Claude Code のバックグラウンド実行で使う
- `Ctrl+g`（ghq_select）/ `Ctrl+r`（fzf_history）/ `Ctrl+v`（fzf 変数）も fish で使用中なので prefix にしない

副作用として、nvim の挿入モード補完 `i_CTRL-X` 系はペイン内に届かなくなる。

## まずこれだけ覚える

| やりたいこと | キー |
|:---|:---|
| **キー一覧を画面に出す** | `Ctrl+x` → `?` |
| **連続移動モードに入る（navigate mode）** | `Ctrl+x` → `g` |
| サイドバー表示 / 非表示 | `Ctrl+x` → `b` |

移動のたびに prefix を押し直すのが面倒なときは navigate mode。
入ったあとは prefix 抜きで `h/j/k/l` がペイン移動、`↑/↓` が space 移動、`Esc` で抜ける。

## 移動キー一覧

以下はすべて `Ctrl+x` を押したあとに続けて押す。

### ペイン

| やりたいこと | キー |
|:---|:---|
| 左 / 下 / 上 / 右のペインへ | `h` / `j` / `k` / `l` |
| 順送り / 逆送り | `Tab` / `Shift+Tab` |
| 最大化（ズーム）トグル | `z` |
| サイズ変更モードに入る | `r` |
| 縦分割 / 横分割 | `v` / `-` |
| ペイン名を付ける | `Shift+p` |
| ペインを閉じる | `x` |
| スクロールバックをエディタで開く | `e` |

### tab

| やりたいこと | キー |
|:---|:---|
| 次 / 前の tab | `n` / `p` |
| 番号で tab へ | `1`〜`9` |
| 新規 tab | `c` |
| tab 名を変える | `Shift+t` |
| tab を閉じる | `Shift+x` |

### spaces（サイドバー上段）

| やりたいこと | キー |
|:---|:---|
| 一覧から選ぶ（picker） | `w` |
| 次 / 前の space | `Shift+j` / `Shift+k` |
| 番号で space へ | `Shift+1`〜`Shift+9` |
| 新規 space | `Shift+n` |
| git worktree を切って space を作る | `Shift+g` |
| space 名を変える | `Shift+w` |
| space を閉じる | `Shift+d` |

space 行には `state_icon` / `workspace`（名前）/ `branch` / `git_status` が出ている。
表示内容は `config.toml` の `[ui.sidebar.spaces]` の `rows` で変えられる。

### agents（サイドバー下段）

| やりたいこと | キー |
|:---|:---|
| 次 / 前のエージェント行へ | `a` / `Shift+a` |
| 番号でエージェントへ | `Alt+1`〜`Alt+9` |
| 通知を出した相手へジャンプ | `o` |

### その他

| やりたいこと | キー |
|:---|:---|
| 設定画面 | `s` |
| 設定を再読み込み | `Shift+r` |
| セッションからデタッチ（プロセスは生き残る） | `q` |

## エージェントの状態を読む

agents パネルのアイコン / 状態表記の意味。

| 状態 | 意味 |
|:---|:---|
| `working` | 動いている |
| `blocked` | 承認待ち・質問待ちの UI を herdr が検出した。**あなたの操作待ち** |
| `idle` | 入力を受け付けられる状態で、かつそのタブを一度見ている |
| `done` | idle と同じ状態だが、**見ていない間に裏で仕事が終わった**もの |
| `unknown` | エージェントは居るが状態を判定できない。終わった証拠にはならない |

`idle` と `done` の違いは「見たかどうか」だけ。タブをフォーカスすると `done` は消える。
CLI から読むだけでは既読にならない。

## 「何をやっているか」を出す設定

既定のエージェント行は `state_icon` / `workspace` / `tab` / `agent` しか出ないので、
`config.toml` で以下を足している。

```toml
[ui.sidebar.agents]
rows = [
    ["state_icon", "state_text", { token = "workspace", bold = true }],
    [{ token = "tab", dim = true }, { token = "agent", dim = true }],
    [{ token = "terminal_title_stripped", dim = true }],
]
```

`terminal_title_stripped` が要点。Claude Code などは端末タイトルに今の作業内容を書くので、
これを行に入れるとサイドバーで作業内容が読める。

使えるトークン:

| トークン | 中身 |
|:---|:---|
| `state_icon` | 状態アイコン |
| `state_text` | 状態の文字表記（working / blocked / …） |
| `workspace` | space 名 |
| `tab` | tab 名 |
| `pane` | ペイン名 |
| `agent` | エージェント種別（claude / codex 等） |
| `terminal_title` | 端末タイトルそのまま |
| `terminal_title_stripped` | 端末タイトルから装飾を落としたもの |
| `$NAME` | エージェントが `herdr pane report-metadata --token NAME=VALUE` で報告した任意の値 |

## 配色の方針

- **テーマは `[theme] name = "terminal"`**。ホストターミナル（Ghostty の `carbonfox`）の配色を
  そのまま使う。既定の `catppuccin` は紫寄りで、ペインの色と別系統になって混ざるため変更した
- **色を使うのは状態（`state_icon` / `state_text`）だけ**。他は `dim` / `bold` の明暗で主従を出す。
  視線が `blocked` に向くようにするのが狙い
- トークンごとのスタイルは文字列の代わりに
  `{ token = "workspace", fg = "#89b4fa", bold = true, dim = false }` と書く。
  **省略した項目は herdr 側の文脈依存の既定が残る**ので、状態トークンに `fg` を指定してはいけない
  （指定すると状態ごとの色分けが消える）
- 他の既定テーマに変えたいときは `catppuccin` / `tokyo-night` / `dracula` / `nord` / `gruvbox` /
  `one-dark` / `solarized` / `kanagawa` / `rose-pine` / `vesper` から選ぶ。
  個別の色だけ上書きするなら `[theme.custom]`（`panel_bg` / `accent` など）

さらに明示的にしたいとき:

- **tab 名を作業内容にする**（`Ctrl+x` → `Shift+t`）。自分で付けた名前が一番読みやすい
- **ペイン名を付ける**（`Ctrl+x` → `Shift+p`）
- `show_agent_labels_on_pane_borders = true`（設定済み）でペイン枠にエージェント名が出る
- 要対応のものを上に集めたいときは `agent_panel_sort = "priority"` にする
  （既定の `"spaces"` は space ごとのグループ表示）

## CLI から覗く・操作する

herdr のペイン内（`$HERDR_ENV` が `1`）なら CLI で現在のセッションを操作できる。

```bash
herdr workspace list                 # space 一覧
herdr agent list                     # エージェントと状態の一覧
herdr agent read <name> --lines 50    # そのエージェントの画面を読む
herdr agent prompt <name> "…" --wait  # プロンプトを送って終わるまで待つ
herdr agent focus <name>             # そのエージェントへ画面を移す
herdr agent rename <name> <new>      # 分かる名前を付ける
herdr pane list                      # ペイン構成
```

ID は `w1`（space）/ `w1:t1`（tab）/ `w1:p1`（pane）。
自分のペインは `$HERDR_WORKSPACE_ID` / `$HERDR_TAB_ID` / `$HERDR_PANE_ID` で取れる。

## 設定を変えたら

```bash
herdr config check          # 検証
herdr server reload-config  # 動いているセッションに反映
```

画面からは `Ctrl+x` → `Shift+r` でも再読み込みできる。

## ハマりどころ

- **prefix キーはペイン内に届かない**。ペイン内のアプリで使いたいキーを prefix にしない
- **日本語入力が ON だと prefix が効かない** → `switch_ascii_input_source_in_prefix = true` で対処済み
- 設定は必ず dotfiles 側（`config/herdr/config.toml`）を編集する。`~/.config` 側は symlink
- 既定値の全量は `herdr --default-config` で確認できる。config.toml には既定から変えたものだけ書く
