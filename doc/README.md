# Neovim 使い方まとめ

このドキュメントは、`dotfiles` の Neovim 設定（`config/nvim`）に基づく使い方の要点をまとめたものです。

## 目次
- 基本設定（オプション）
- キーマップ（共通）
- ファイル操作（nvim-tree）
- 検索/ジャンプ（telescope）
- Lint/Format
- Git（gina, git.nvim, gitsigns）
- ターミナル（toggleterm）
- ウィンドウ操作（vim-maximizer）
- マーク/ジャンプ（harpoon）
- コメント（Comment.nvim）
- 囲み操作（nvim-surround）
- 括弧補完（nvim-autopairs）
- Markdown/Previm/Memolist
- 起動画面（alpha-nvim）

## 基本設定（オプション）
- リーダーキー: スペース
- 行番号表示: 通常行番号（相対行番号は無効）
- マウス有効化、真の色（termguicolors）有効化
- `cmdheight = 2`、`laststatus = 3`、`showtabline = 2`
- インデント: スペース2、`smartindent` 有効
- 検索: `hlsearch`, `incsearch`, `ignorecase` + `smartcase`
- スクロール余白: `scrolloff = 10`
- クリップボード: macOS では `unnamed`
- シェル: `fish`
- ヘルプ言語: `ja,en`

## キーマップ（共通）
- 画面分割
  - `ss`: 水平分割 + 次ウィンドウへ
  - `sv`: 垂直分割 + 次ウィンドウへ
- ウィンドウ移動: `sh`, `sj`, `sk`, `sl`
- 設定を開く: `<F1>`
- 通知履歴: `<leader>nh`
- 通知クリア: `<leader>nc`

## ファイル操作（nvim-tree）
- `<leader>ee`: トグル表示
- `<leader>ef`: 現在ファイル位置でトグル
- `<leader>ec`: 折りたたみ
- `<leader>er`: リフレッシュ

## 検索/ジャンプ（telescope）
- `<leader>ff`: ファイル検索
- `<leader>fg`: ライブグレップ
- `<leader>fe`: egrepify（拡張検索）
- `<leader>fd`: 診断
- `<leader>fl`: カレントバッファ検索
- `<leader>fh`: ヘルプ（日本語指定）
- `<leader>fo`: 最近使ったファイル
- `<leader>fs`: Git ステータス
- `<leader>fc`: コマンド一覧
- `<leader>s`: LSP シンボル

## Lint/Format
- Lint（nvim-lint）
  - 自動実行: `BufEnter`, `BufWritePost`, `InsertLeave`
  - 手動実行: `<leader>l`
  - linters: eslint_d（JS/TS/React/Svelte）、pylint（Python）
- Format（conform.nvim）
  - 設定済（フォーマッタ個別指定は未設定）。必要に応じて `opts.formatters_by_ft` を拡張。

## Git
- gina.vim（メインフロー）
  - 基本起動: `gs`（status）、`gl`（log）、`gm`（blame）、`gb`（branch）
  - URLコピー: `gu`（ノーマル/ビジュアル）
  - status バッファ内: `gp` push、`gl` pull、`cm` commit、`ca` amend、`dp` パッチ、`gc` chaperon ほか
- git.nvim（補助）
  - `<leader>gb`: blame、`<leader>gd`: diff、`<leader>gD`: diff close
  - `<leader>go`: repo を開く、`<leader>gp`: PR を開く、`<leader>gn`: PR 作成
- gitsigns.nvim: 行差分表示（キーマップはデフォルト）

## ターミナル（toggleterm）
- 既定トグル: `<C-\>`
- 表示: フロート、開始時 insert 非。

## ウィンドウ操作（vim-maximizer）
- `<leader>sm`: 分割の最大化/戻す

## マーク/ジャンプ（harpoon）
- `<leader>hm`: 現在ファイルをマーク
- `<leader>hn`: 次のマークへ
- `<leader>hp`: 前のマークへ

## コメント（Comment.nvim）
- `gc` 系のプレフィックスでトグル（例: `gcc` 行、`gc` 選択範囲）
- TS コンテキストに応じたコメント文字を自動判定

## 囲み操作（nvim-surround）
- 代表例
  - `ysiw"`: 単語を " で囲む
  - `cs"'`: " を ' に変更
  - `ds"`: " の囲みを削除

## 括弧補完（nvim-autopairs）
- Insert 中の括弧やクォートの自動補完
- nvim-cmp と連携（`confirm_done`）

## Markdown/Previm/Memolist
- Markdown: `plasticboy/vim-markdown`（フォールディング無効）
- Previm: Markdown プレビュー（`ft=markdown` 時）
- Memolist: `:MemoList`, `:MemoNew`

## 起動画面（alpha-nvim）
- 起動後のダッシュボードに以下ボタン
  - `f`: Find File、`n`: New File、`r`: Recent Files、`g`: Live Grep、`c`: Config、`q`: Quit

## 補足（Treesitter Textobjects）
- 移動: `]m`/`[m`（関数定義）、`]c`/`[c`（クラス）など
- 選択: `am`/`im`（関数）、`ac`/`ic`（クラス） ほか
- 置換スワップ: `<leader>na`, `<leader>pa` など（パラメータ/関数/プロパティ）
- リピート: `;` / `,` で直前の move をリピート、`fFtT` もリピート対応

## 既知のリーダーキー
- `<leader>` はスペース

---
- さらに詳しい設定は `config/nvim/lua/my` 以下の各ファイルを参照してください。
