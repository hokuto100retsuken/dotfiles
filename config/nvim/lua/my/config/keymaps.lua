-- set leader key to space
local keymap = vim.keymap

-- General keymaps --
-- キーバインド
-- 画面分割
keymap.set('n', 'ss', ':split<Return><C-w>w')
keymap.set('n', 'sv', ':vsplit<Return><C-w>w')
-- アクティブウィンドウの移動
keymap.set('n', 'sh', '<C-w>h')
keymap.set('n', 'sk', '<C-w>k')
keymap.set('n', 'sj', '<C-w>j')
keymap.set('n', 'sl', '<C-w>l')

-- Emacs風
-- keymap.set('i', '<C-f>', '<Right>')
-- jjでEscする
-- keymap.set('i','jj','<Esc>')
-- 設定ファイルを開く
keymap.set('n','<F1>',':edit $MYVIMRC<CR>')

-- 通知システムのキーマップ
-- 通知履歴を表示
keymap.set('n', '<leader>nh', ':lua require("notify").history()<CR>')
-- 通知をクリア
keymap.set('n', '<leader>nc', ':lua require("notify").dismiss()<CR>')
