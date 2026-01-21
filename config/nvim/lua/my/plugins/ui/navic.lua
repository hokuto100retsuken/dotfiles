-- This file configures nvim-navic, which shows the current code context in the winbar/statusline.
-- このファイルは、winbar/statuslineで現在のコードコンテキストを表示するnvim-navicを設定します。

local navic = {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("nvim-navic").setup({
      -- Configuration options for nvim-navic.
      -- nvim-navicの設定オプション。
      highlight = true, -- Highlight the current context.
      -- 現在のコンテキストをハイライトします。
      separator = " > ", -- Separator between context items.
      -- コンテキスト項目間のセパレータ。
      depth_limit = 0, -- Maximum depth to show (0 = unlimited).
      -- 表示する最大深度（0 = 無制限）。
      depth_limit_indicator = "..", -- Indicator for truncated context.
      -- 切り詰められたコンテキストのインジケータ。
    })
  end,
}

return navic
