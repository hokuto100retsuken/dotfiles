-- This file configures registers.nvim, which provides a preview UI for the contents of Neovim registers.
-- このファイルは、Neovimレジスタの内容をプレビューするUIを提供するregisters.nvimを設定します。

local registers = {
  "tversteeg/registers.nvim",
  config = function()
    require("registers").setup({
      -- Configuration options for registers.nvim.
      -- registers.nvimの設定オプション。
      show_empty = true, -- Show empty registers.
      -- 空のレジスタを表示します。
      show_whitespace = false, -- Don't show whitespace-only registers.
      -- 空白のみのレジスタを表示しません。
      -- The plugin automatically shows the window when pressing " in normal/visual mode or Ctrl+R in insert mode.
      -- プラグインは、通常/ビジュアルモードで"を押すか、挿入モードでCtrl+Rを押すと自動的にウィンドウを表示します。
    })
  end,
}

return registers
