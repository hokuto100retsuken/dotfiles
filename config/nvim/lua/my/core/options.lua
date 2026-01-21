-- This file sets basic Neovim options.
-- このファイルはNeovimの基本的なオプションを設定します。
-- For more information, see :help options

local opt = vim.opt -- For setting options (e.g., vim.opt.tabstop) / オプション設定用
local g = vim.g     -- For setting global variables (e.g., vim.g.mapleader) / グローバル変数設定用

-- ┃ Global Variables / グローバル変数 ┃
-- These variables are accessible globally in Neovim.
-- これらの変数はNeovim全体でグローバルにアクセス可能です。

-- Set the leader key to a space.
-- リーダーキーをスペースに設定します。
-- e.g. <Space>ff
g.mapleader = " "
g.maplocalleader = " "

-- For markdown preview
-- markdown-preview.nvim用の設定
g["markdown_recommended_style"] = 0


-- ┃ File and Buffer Settings / ファイルとバッファの設定 ┃
-- Settings related to file encoding, backup, and buffer behavior.
-- ファイルのエンコーディング、バックアップ、バッファの挙動に関する設定。
opt.encoding = 'utf-8'                  -- Set default encoding to UTF-8 / デフォルトのエンコーディングをUTF-8に設定
opt.fileencoding = 'utf-8'              -- Set file encoding to UTF-8 / ファイルのエンコーディングをUTF-8に設定
opt.fileencodings = 'utf-8,euc-jp,shift-jis' -- Set fallback file encodings / フォールバック用のエンコーディングを設定
opt.swapfile = false                    -- Disable swap files / スワップファイルを無効化
opt.autowrite = true                    -- Automatically write files when switching buffers / バッファ切り替え時に自動で書き込む
opt.hidden = true                       -- Allow hidden buffers / バッファを隠すことを許可


-- ┃ UI Settings / UI関連の設定 ┃
-- Controls the appearance of the Neovim interface.
-- Neovimインターフェースの外観を制御します。
opt.number = true                       -- Show line numbers / 行番号を表示
opt.relativenumber = true               -- Show relative line numbers / 相対行番号を表示
opt.termguicolors = true                -- Enable 24-bit RGB colors / 24ビットRGBカラーを有効化
opt.title = true                        -- Set the window title / ウィンドウのタイトルを設定
opt.mouse = 'a'                         -- Enable mouse support in all modes / 全モードでマウスサポートを有効化
opt.cursorline = true                   -- Highlight the current line / 現在の行をハイライト
opt.signcolumn = 'yes'                  -- Always show the sign column / 常にサインカラムを表示
opt.showcmd = true                      -- Show the command being typed / 入力中のコマンドを表示
opt.cmdheight = 1                       -- Set command line height / コマンドラインの高さを設定
opt.laststatus = 3                      -- Always display the status line / 常にステータスラインを表示
opt.showtabline = 2                     -- Always display the tab line / 常にタブラインを表示
opt.winblend = 5                        -- Set transparency for floating windows / フローティングウィンドウの透明度を設定
opt.scrolloff = 10                      -- Keep 10 lines of context around the cursor / カーソル周辺に10行のコンテキストを維持
opt.winbar = "%=%{%v:lua.require'nvim-navic'.get_location()%}" -- Show code context in winbar / winbarでコードコンテキストを表示


-- ┃ Editing Settings / 編集関連の設定 ┃
-- Settings that affect typing, indentation, and text wrapping.
-- タイピング、インデント、テキストの折り返しに影響する設定。

-- Indentation / インデント
opt.autoindent = true                   -- Copy indent from current line when starting a new line / 新しい行で現在の行のインデントをコピー
opt.smartindent = true                  -- Insert indent automatically / 自動でインデントを挿入
opt.expandtab = true                    -- Use spaces instead of tabs / タブの代わりにスペースを使用
opt.shiftwidth = 2                      -- Set shift width to 2 spaces / インデント幅を2スペースに設定
opt.tabstop = 2                         -- Set tab stop to 2 spaces / タブの表示幅を2スペースに設定
opt.softtabstop = 2                     -- Set soft tab stop to 2 spaces / ソフトタブストップを2スペースに設定
opt.smarttab = true                     -- Enable smart tabs / スマートタブを有効化

-- Wrapping and Formatting / 折り返しとフォーマット
opt.wrap = true                         -- Wrap lines / 行を折り返す
opt.breakindent = true                  -- Preserve indentation on wrapped lines / 折り返し行のインデントを維持
opt.virtualedit = "block"               -- Allow cursor to move where there is no text in visual block mode / ビジュアルブロックモードでテキストがない場所にもカーソルを移動可能に

-- Clipboard / クリップボード
-- Use system clipboard for all operations
-- すべての操作でシステムのクリップボードを使用します
opt.clipboard:append({ vim.fn.has('mac') == 1 and 'unnamed' or 'unnamedplus' })


-- ┃ Search Settings / 検索関連の設定 ┃
-- Configure how search operations behave.
-- 検索操作の挙動を設定します。
opt.hlsearch = true                     -- Highlight search results / 検索結果をハイライト
opt.incsearch = true                    -- Show search results incrementally / 検索結果をインクリメンタルに表示
opt.ignorecase = true                   -- Ignore case in search / 検索時に大文字小文字を無視
opt.smartcase = true                    -- Override ignorecase if the search pattern has uppercase letters / 検索パターンに大文字が含まれている場合は大文字小文字を区別


-- ┃ Command and Execution Settings / コマンドと実行に関する設定 ┃
-- Settings for shell commands, completion, and help.
-- シェルコマンド、補完、ヘルプに関する設定。
opt.shell = 'fish'                      -- Set the default shell / デフォルトのシェルを設定
opt.inccommand = 'split'                -- Show replacements in a split window as you type / 入力中に置換をスプリットウィンドウでプレビュー
opt.updatetime = 300                    -- Set update time for faster completion and other events / 補完やその他のイベントのための更新時間
opt.completeopt = 'menuone,noselect' -- Set completion options / 補完オプションを設定
opt.helplang = 'ja,en'                  -- Set preferred help languages / ヘルプの優先言語を設定
opt.grepprg = 'rg --vimgrep'            -- Use ripgrep for :grep / :grepにripgrepを使用
opt.grepformat = '%f:%l:%c:%m'          -- Set grep format / grepのフォーマットを設定
