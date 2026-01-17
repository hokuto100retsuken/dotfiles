-- This file defines the keybindings for Neovim.
-- For more information, see :help key-mapping

local keymap = vim.keymap

-- ┃ Window Management ┃
-- Split windows
keymap.set('n', 'ss', ':split<Return><C-w>w', { silent = true, desc = 'Split window horizontally' })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { silent = true, desc = 'Split window vertically' })
-- Move between windows
keymap.set('n', 'sh', '<C-w>h', { silent = true, desc = 'Move to left window' })
keymap.set('n', 'sk', '<C-w>k', { silent = true, desc = 'Move to upper window' })
keymap.set('n', 'sj', '<C-w>j', { silent = true, desc = 'Move to lower window' })
keymap.set('n', 'sl', '<C-w>l', { silent = true, desc = 'Move to right window' })


-- ┃ Applications ┃
-- Lazygit
keymap.set('n', '<leader>gg', '<Cmd>lua _LAZYGIT_TOGGLE()<CR>', { silent = true, desc = 'Toggle Lazygit' })

-- Notifications
keymap.set('n', '<leader>nh', ':lua require("notify").history()<CR>', { silent = true, desc = 'Show notification history' })
keymap.set('n', '<leader>nc', ':lua require("notify").dismiss()<CR>', { silent = true, desc = 'Dismiss all notifications' })


-- ┃ Editor Behavior ┃
-- Edit Neovim config
keymap.set('n', '<F1>', ':edit $MYVIMRC<CR>', { silent = true, desc = 'Edit init.lua' })
