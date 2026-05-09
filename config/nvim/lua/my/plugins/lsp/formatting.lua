-- This file configures conform.nvim, a formatter for Neovim.
-- このファイルは、Neovim用のフォーマッターであるconform.nvimを設定します。

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  config = function()
    require("conform").setup({
      -- Configuration options for conform.nvim.
      -- conform.nvimの設定オプション。

      -- Disable auto-format on save by default.
      -- 保存時の自動フォーマットをデフォルトで無効化。
      format_on_save = false,

      -- Formatters for specific file types.
      -- 特定のファイルタイプのフォーマッター。
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        go = { "gofumpt", "goimports" },
        php = { "php_cs_fixer" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        vue = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
      },
    })
  end,
}
