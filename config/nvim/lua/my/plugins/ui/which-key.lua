-- This file configures which-key.nvim, which displays a popup with possible keybindings.
-- このファイルは、可能なキーバインディングをポップアップで表示するwhich-key.nvimを設定します。

local wk = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    -- Enable timeout for which-key to trigger.
    -- which-keyがトリガーされるためのタイムアウトを有効化します。
    vim.o.timeout = true
    vim.o.timeoutlen = 500 -- Timeout length in milliseconds.
    -- タイムアウトの長さ（ミリ秒）。
  end,
  -- Use default settings to avoid configuration warnings.
  -- 設定警告を避けるためにデフォルト設定を使用します。
  opts = {},
}

return wk
