-- This file defines the keybindings for Neovim.
-- For more information, see :help key-mapping

local keymap = vim.keymap

-- ┃ Window Management ┃
-- Neovimのウィンドウ分割と移動のキーマップ
-- Ghosttyのキーマップ（ctrl+h/j/k/l, ctrl+w）と被らないように設定
-- 標準的なVimのキーマップ（Ctrl+w + キー）も使用可能

-- ウィンドウ分割（Neovim内でのみ有効、Ghosttyと被らない）
keymap.set('n', 'ss', ':split<Return><C-w>w', { silent = true, desc = 'Split window horizontally' })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { silent = true, desc = 'Split window vertically' })

-- ウィンドウ間の移動
-- 標準的なVimのキーマップ（Ctrl+w + h/j/k/l）は使用可能
-- ただし、Ghosttyのctrl+h/j/k/lと被るため、Neovim内では以下のキーマップも使用可能
keymap.set('n', '<leader>wh', '<C-w>h', { silent = true, desc = 'Move to left window' })
keymap.set('n', '<leader>wj', '<C-w>j', { silent = true, desc = 'Move to lower window' })
keymap.set('n', '<leader>wk', '<C-w>k', { silent = true, desc = 'Move to upper window' })
keymap.set('n', '<leader>wl', '<C-w>l', { silent = true, desc = 'Move to right window' })

-- ウィンドウを閉じる
-- 標準的なVimのキーマップ（Ctrl+w q）も使用可能
keymap.set('n', '<leader>wq', '<C-w>q', { silent = true, desc = 'Close window' })


-- ┃ Applications ┃
-- Lazygit
keymap.set('n', '<leader>gg', '<Cmd>lua _LAZYGIT_TOGGLE()<CR>', { silent = true, desc = 'Toggle Lazygit' })

-- Notifications
keymap.set('n', '<leader>nh', ':lua require("notify").history()<CR>', { silent = true, desc = 'Show notification history' })
keymap.set('n', '<leader>nc', ':lua require("notify").dismiss()<CR>', { silent = true, desc = 'Dismiss all notifications' })


-- ┃ Editor Behavior ┃
-- Edit Neovim config
keymap.set('n', '<F1>', ':edit $MYVIMRC<CR>', { silent = true, desc = 'Edit init.lua' })
