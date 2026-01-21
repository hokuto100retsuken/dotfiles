-- This file configures lspsaga.nvim, which provides a UI for LSP features.
-- このファイルは、LSP機能のUIを提供するlspsaga.nvimを設定します。

local lspsaga = {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Optional: For better highlighting.
    -- オプション: より良いハイライトのために使用します。
    "nvim-tree/nvim-web-devicons", -- Optional: For icons.
    -- オプション: アイコンのために使用します。
  },
  config = function()
    require("lspsaga").setup({
      -- Configuration options for lspsaga.
      -- lspsagaの設定オプション。

      -- UI configuration.
      -- UI設定。
      ui = {
        -- Border style for floating windows.
        -- フローティングウィンドウのボーダースタイル。
        border = "rounded",
        -- Code action icon.
        -- コードアクションアイコン。
        code_action = "💡",
      },

      -- Symbol in winbar configuration.
      -- winbarでのシンボル設定。
      -- Disabled because lualine.nvim manages winbar.
      -- lualine.nvimがwinbarを管理するため無効化します。
      symbol_in_winbar = {
        enable = false, -- Disable symbol in winbar to avoid conflict with lualine.
        -- lualineとの競合を避けるため、winbarでのシンボルを無効化します。
      },

      -- Lightbulb configuration.
      -- 電球設定。
      lightbulb = {
        enable = true, -- Enable lightbulb icon.
        -- 電球アイコンを有効化します。
        enable_in_insert = true, -- Show in insert mode.
        -- 挿入モードでも表示します。
        sign = true, -- Show sign.
        -- サインを表示します。
        sign_priority = 20, -- Sign priority.
        -- サインの優先度。
      },

      -- Hover configuration.
      -- ホバー設定。
      hover = {
        max_width = 0.6, -- Maximum width of hover window.
        -- ホバーウィンドウの最大幅。
        max_height = 0.8, -- Maximum height of hover window.
        -- ホバーウィンドウの最大高さ。
      },

      -- Diagnostic configuration.
      -- 診断設定。
      diagnostic = {
        show_code_action = true, -- Show code actions in diagnostics.
        -- 診断でコードアクションを表示します。
        show_source = true, -- Show diagnostic source.
        -- 診断のソースを表示します。
      },
    })
  end,
}

return lspsaga
