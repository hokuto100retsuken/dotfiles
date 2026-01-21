-- This file configures lualine.nvim, a blazing fast and easy to configure statusline plugin.
-- このファイルは、高速で設定が簡単なステータスラインプラグインであるlualine.nvimを設定します。

local lualine = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "EdenEast/nightfox.nvim", -- Ensure nightfox is loaded before lualine.
    -- lualineの前にnightfoxが読み込まれるようにします。
  },
  config = function()
    -- According to nightfox.nvim documentation, colorscheme must be set before lualine setup.
    -- nightfox.nvimのドキュメントによると、カラースキームはlualineのsetupの前に設定する必要があります。
    -- Wait for colorscheme to be loaded.
    -- カラースキームが読み込まれるまで待機します。
    vim.schedule(function()
      if not vim.g.colors_name then
        vim.cmd.colorscheme("carbonfox")
      end

      require("lualine").setup({
      options = {
        theme = "auto", -- Use auto theme detection from vim.g.colors_name.
        -- vim.g.colors_nameから自動テーマ検出を使用します。
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      })
    end)
  end,
}

return lualine
