-- Load core configuration files for Neovim.
-- Neovimのコア設定ファイルを読み込みます。

-- optionsは起動直後に必要なので即座に読み込む
require('my.core.options')

-- keymapsとautocmdsはUI準備完了後に遅延読み込み
vim.schedule(function()
  require('my.core.keymaps')
  require('my.core.autocmds')
end)
