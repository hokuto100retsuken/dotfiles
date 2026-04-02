-- This file configures snacks.nvim, a collection of quality-of-life plugins for Neovim.
-- このファイルは、Neovim用のQoLプラグインのコレクションであるsnacks.nvimを設定します。

local snacks = {
  "folke/snacks.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ee", function() Snacks.explorer.open() end, desc = "Toggle file explorer" },
  },
  config = function()
    require("snacks").setup({
      bigfile = {
        enabled = true,
        filesize = 2,
      },
      indent = { enabled = true },
      scope = { enabled = true },
      dashboard = { enabled = true },
      quickfile = { enabled = true },
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
    })
  end,
}

return snacks
