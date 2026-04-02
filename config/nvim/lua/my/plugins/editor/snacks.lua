-- This file configures snacks.nvim, a collection of quality-of-life plugins for Neovim.
-- このファイルは、Neovim用のQoLプラグインのコレクションであるsnacks.nvimを設定します。

local snacks = {
  "folke/snacks.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ee", function() Snacks.explorer.open() end, desc = "Toggle file explorer" },
    -- Picker (telescope代替)
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
    { "<leader>fo", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fs", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>s", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    -- Notifier
    { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Show notification history" },
    { "<leader>nc", function() Snacks.notifier.hide() end, desc = "Dismiss all notifications" },
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
      picker = { enabled = true },
      notifier = { enabled = true },
    })
  end,
}

return snacks
