-- This file configures lualine.nvim, a blazing fast and easy to configure statusline plugin.
-- このファイルは、高速で設定が簡単なステータスラインプラグインであるlualine.nvimを設定します。

local lualine = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "SmiteshP/nvim-navic", -- For code context display in winbar.
    -- winbarでコードコンテキストを表示するために使用します。
  },
  config = function()
    local lualine = require("lualine")
    local navic = require("nvim-navic")

    -- Helper function to check if navic is available.
    -- navicが利用可能かどうかを確認するヘルパー関数。
    local function navic_component()
      return navic.get_location()
    end

    -- Configure lualine with oxocarbon theme.
    -- oxocarbonテーマでlualineを設定します。
    lualine.setup({
      options = {
        theme = "oxocarbon", -- Use oxocarbon theme to match colorscheme.
        -- カラースキームに合わせてoxocarbonテーマを使用します。
      },
      sections = {
        lualine_a = { "mode" }, -- Show current mode.
        -- 現在のモードを表示します。
        lualine_b = { "branch", "diff", "diagnostics" }, -- Show git branch, diff, and diagnostics.
        -- Gitブランチ、差分、診断情報を表示します。
        lualine_c = {
          {
            "filename",
            path = 1, -- Show relative path (0 = filename only, 1 = relative path, 2 = absolute path, 3 = full path).
            -- 相対パスを表示します（0 = ファイル名のみ、1 = 相対パス、2 = 絶対パス、3 = フルパス）。
          },
        },
        lualine_x = {
          { "encoding" }, -- Show file encoding.
          -- ファイルエンコーディングを表示します。
          { "fileformat" }, -- Show file format (unix, dos, mac).
          -- ファイルフォーマットを表示します（unix、dos、mac）。
          { "filetype" }, -- Show file type.
          -- ファイルタイプを表示します。
        },
        lualine_y = { "progress" }, -- Show cursor position.
        -- カーソル位置を表示します。
        lualine_z = { "location" }, -- Show cursor location.
        -- カーソル位置を表示します。
      },
      winbar = {
        -- Winbar configuration for code context display.
        -- コードコンテキスト表示用のwinbar設定。
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            navic_component,
            cond = navic.is_available, -- Only show if navic is available.
            -- navicが利用可能な場合のみ表示します。
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        -- Inactive winbar configuration.
        -- 非アクティブなwinbar設定。
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}

return lualine
