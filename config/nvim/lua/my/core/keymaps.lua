-- This file defines the keybindings for Neovim.
-- このファイルはNeovimのキーバインディングを定義します。
-- For more information, see :help key-mapping

local keymap = vim.keymap

-- ┃ Window Management / ウィンドウ管理 ┃
-- Window split and navigation keymaps for Neovim.
-- Neovimのウィンドウ分割と移動のキーマップ。
-- Configured to avoid conflicts with Ghostty keymaps (ctrl+h/j/k/l, ctrl+w).
-- Ghosttyのキーマップ（ctrl+h/j/k/l, ctrl+w）と被らないように設定。
-- Standard Vim keymaps (Ctrl+w + key) are also available.
-- 標準的なVimのキーマップ（Ctrl+w + キー）も使用可能。

-- Window splitting (only effective in Neovim, avoids conflict with Ghostty).
-- ウィンドウ分割（Neovim内でのみ有効、Ghosttyと被らない）。
keymap.set("n", "ss", ":split<Return><C-w>w", { silent = true, desc = "Split window horizontally" })
keymap.set("n", "sv", ":vsplit<Return><C-w>w", { silent = true, desc = "Split window vertically" })

-- Window navigation.
-- ウィンドウ間の移動。
-- Standard Vim keymaps (Ctrl+w + h/j/k/l) are available.
-- 標準的なVimのキーマップ（Ctrl+w + h/j/k/l）は使用可能。
-- However, since Ghostty's ctrl+h/j/k/l conflicts, the following keymaps are also available in Neovim.
-- ただし、Ghosttyのctrl+h/j/k/lと被るため、Neovim内では以下のキーマップも使用可能。
keymap.set("n", "<leader>wh", "<C-w>h", { silent = true, desc = "Move to left window" })
keymap.set("n", "<leader>wj", "<C-w>j", { silent = true, desc = "Move to lower window" })
keymap.set("n", "<leader>wk", "<C-w>k", { silent = true, desc = "Move to upper window" })
keymap.set("n", "<leader>wl", "<C-w>l", { silent = true, desc = "Move to right window" })

-- Close window.
-- ウィンドウを閉じる。
-- Standard Vim keymap (Ctrl+w q) is also available.
-- 標準的なVimのキーマップ（Ctrl+w q）も使用可能。
keymap.set("n", "<leader>wq", "<C-w>q", { silent = true, desc = "Close window" })

-- ┃ Applications / アプリケーション ┃
-- Lazygit integration.
-- Lazygitの統合。
keymap.set("n", "<leader>gg", "<Cmd>lua _LAZYGIT_TOGGLE()<CR>", { silent = true, desc = "Toggle Lazygit" })

-- Notification management.
-- 通知の管理。
keymap.set("n", "<leader>nh", ":lua require('notify').history()<CR>", { silent = true, desc = "Show notification history" })
keymap.set("n", "<leader>nc", ":lua require('notify').dismiss()<CR>", { silent = true, desc = "Dismiss all notifications" })

-- ┃ Editor Behavior / エディタの動作 ┃
-- Edit Neovim configuration.
-- Neovim設定を編集。
keymap.set("n", "<F1>", ":edit $MYVIMRC<CR>", { silent = true, desc = "Edit init.lua" })

-- Clear search highlights.
-- 検索ハイライトをクリア。
keymap.set("n", "<leader>h", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlights" })

-- Quick save (using <leader>ww to avoid conflict with window group).
-- クイック保存（ウィンドウグループとの競合を避けるために<leader>wwを使用）。
keymap.set("n", "<leader>ww", ":write<CR>", { silent = true, desc = "Save file" })

-- Quick quit (using <leader>qq to avoid conflict).
-- クイック終了（競合を避けるために<leader>qqを使用）。
keymap.set("n", "<leader>qq", ":quit<CR>", { silent = true, desc = "Quit" })
