-- This file defines the keybindings for Neovim.
-- このファイルはNeovimのキーバインディングを定義します。
-- For more information, see :help key-mapping

local keymap = vim.keymap

-- ┃ Window Management / ウィンドウ管理 ┃
keymap.set("n", "ss", ":split<Return><C-w>w", { silent = true, desc = "Split horizontally" })
keymap.set("n", "sv", ":vsplit<Return><C-w>w", { silent = true, desc = "Split vertically" })

-- Window navigation (Ctrl+h/j/k/l — Ghosttyはctrl+shift+h/j/k/lなので競合しない)
keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Move to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Move to lower window" })
keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Move to upper window" })
keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Move to right window" })

-- Close window
keymap.set("n", "<leader>wq", "<C-w>q", { silent = true, desc = "Close window" })

-- ┃ Buffer Management / バッファ管理 ┃
-- bufferline の番号で直接ジャンプ
keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", { silent = true, desc = "Go to buffer 1" })
keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", { silent = true, desc = "Go to buffer 2" })
keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", { silent = true, desc = "Go to buffer 3" })
keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", { silent = true, desc = "Go to buffer 4" })
keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", { silent = true, desc = "Go to buffer 5" })
keymap.set("n", "H", "<cmd>BufferLineCyclePrev<CR>", { silent = true, desc = "Previous buffer" })
keymap.set("n", "L", "<cmd>BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { silent = true, desc = "Close buffer" })

-- ┃ Applications / アプリケーション ┃
keymap.set("n", "<leader>gg", "<Cmd>lua _LAZYGIT_TOGGLE()<CR>", { silent = true, desc = "Toggle Lazygit" })

-- Notification management
keymap.set("n", "<leader>nh", ":lua require('notify').history()<CR>", { silent = true, desc = "Show notification history" })
keymap.set("n", "<leader>nc", ":lua require('notify').dismiss()<CR>", { silent = true, desc = "Dismiss all notifications" })

-- ┃ Editor Behavior / エディタの動作 ┃
keymap.set("n", "<F1>", ":edit $MYVIMRC<CR>", { silent = true, desc = "Edit init.lua" })
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlights" })

-- Save / Quit
keymap.set("n", "<leader>w", ":write<CR>", { silent = true, desc = "Save file" })
keymap.set("n", "<leader>q", ":quit<CR>", { silent = true, desc = "Quit" })
keymap.set("n", "<leader>Q", ":qa<CR>", { silent = true, desc = "Quit all" })

-- ┃ Move lines / 行の移動 ┃
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- ┃ Better defaults / より良いデフォルト ┃
-- ペースト時にレジスタを上書きしない
keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })
-- J で行結合した時にカーソル位置を維持
keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })
-- 検索ジャンプ時に画面中央を維持
keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
-- 半ページジャンプ時に画面中央を維持
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
