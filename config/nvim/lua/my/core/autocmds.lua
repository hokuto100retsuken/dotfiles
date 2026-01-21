-- This file defines autocommands, which are commands that are automatically executed when certain events occur.
-- このファイルは、特定のイベントが発生したときに自動的に実行されるコマンドであるautocommandを定義します。
-- For more information, see :help autocommand

local augroup = vim.api.nvim_create_augroup -- Create a new augroup.
-- 新しいaugroupを作成します。
local autocmd = vim.api.nvim_create_autocmd -- Create a new autocommand.
-- 新しいautocommandを作成します。

-- Define groups for user-defined autocommands.
-- ユーザー定義のautocommandのグループを定義します。
local my_autocommands = augroup("MyAutoCommands", { clear = true })
local format_group = augroup("FormatGroup", { clear = true })
local restore_cursor_group = augroup("RestoreCursorGroup", { clear = true })

-- ┃ File Formatting / ファイルフォーマット ┃
-- Auto-format on save (disabled by default, can be enabled per filetype).
-- 保存時の自動フォーマット（デフォルトでは無効、ファイルタイプごとに有効化可能）。
autocmd("BufWritePre", {
  group = format_group,
  pattern = "*",
  callback = function()
    -- Format using conform.nvim if available.
    -- 利用可能な場合はconform.nvimを使用してフォーマットします。
    local ok, conform = pcall(require, "conform")
    if ok and conform then
      conform.format({ async = false, lsp_fallback = true })
    end
  end,
  desc = "Auto-format on save",
})

-- ┃ Cursor Position Restoration / カーソル位置の復元 ┃
-- Restore cursor position when opening a file.
-- ファイルを開くときにカーソル位置を復元します。
autocmd("BufReadPost", {
  group = restore_cursor_group,
  pattern = "*",
  callback = function()
    -- Restore cursor to last position if it's valid.
    -- 有効な場合は最後の位置にカーソルを復元します。
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore cursor position",
})

-- ┃ File Type Specific Settings / ファイルタイプ固有の設定 ┃
-- Set options for specific file types.
-- 特定のファイルタイプのオプションを設定します。

-- Markdown and text files.
-- Markdownとテキストファイル。
autocmd("FileType", {
  group = my_autocommands,
  pattern = "markdown,txt",
  callback = function()
    vim.opt_local.wrap = true -- Enable line wrapping.
    -- 行の折り返しを有効化します。
    vim.opt_local.spell = true -- Enable spellcheck.
    -- スペルチェックを有効化します。
  end,
  desc = "Enable wrap and spellcheck for text files",
})

-- Git commit messages.
-- Gitコミットメッセージ。
autocmd("FileType", {
  group = my_autocommands,
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.wrap = true -- Enable line wrapping.
    -- 行の折り返しを有効化します。
    vim.opt_local.spell = true -- Enable spellcheck.
    -- スペルチェックを有効化します。
  end,
  desc = "Enable wrap and spellcheck for git commit messages",
})

-- ┃ Terminal Settings / ターミナル設定 ┃
-- Automatically enter insert mode when opening a terminal.
-- ターミナルを開くときに自動的に挿入モードに入ります。
autocmd("TermOpen", {
  group = my_autocommands,
  pattern = "*",
  command = "startinsert",
  desc = "Enter insert mode when opening a terminal",
})

-- ┃ Highlight on Yank / ヤンク時のハイライト ┃
-- Highlight yanked text briefly.
-- ヤンクしたテキストを短時間ハイライトします。
autocmd("TextYankPost", {
  group = my_autocommands,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200, -- Highlight duration in milliseconds.
      -- ハイライトの持続時間（ミリ秒）。
    })
  end,
  desc = "Highlight yanked text",
})

-- ┃ Auto-resize Windows / ウィンドウの自動リサイズ ┃
-- Auto-resize windows when Vim is resized.
-- Vimがリサイズされたときにウィンドウを自動リサイズします。
autocmd("VimResized", {
  group = my_autocommands,
  pattern = "*",
  command = "wincmd =",
  desc = "Auto-resize windows on Vim resize",
})

-- ┃ Remove Trailing Whitespace / 末尾の空白を削除 ┃
-- Remove trailing whitespace on save for specific file types.
-- 特定のファイルタイプで保存時に末尾の空白を削除します。
autocmd("BufWritePre", {
  group = my_autocommands,
  pattern = { "*.lua", "*.py", "*.js", "*.ts", "*.tsx", "*.vue", "*.go", "*.rs" },
  callback = function()
    -- Remove trailing whitespace.
    -- 末尾の空白を削除します。
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace on save",
})

