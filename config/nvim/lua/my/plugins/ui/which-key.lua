-- This file configures which-key.nvim, which displays a popup with possible keybindings.
-- このファイルは、可能なキーバインディングをポップアップで表示するwhich-key.nvimを設定します。

local wk = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 400
  end,
  config = function()
    local which_key = require("which-key")
    which_key.setup({})
    which_key.add({
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>e", group = "Explorer" },
      { "<leader>g", group = "Git" },
      { "<leader>x", group = "Diagnostics" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>b", group = "Buffer" },
      { "<leader>n", group = "Notification" },
      { "<leader>w", desc = "Save file" },
      { "<leader>q", desc = "Quit" },
    })
  end,
}

return wk
