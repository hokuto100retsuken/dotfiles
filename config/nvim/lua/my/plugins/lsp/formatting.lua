-- This file configures conform.nvim, a formatter for Neovim.
-- このファイルは、Neovim用のフォーマッターであるconform.nvimを設定します。

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  config = function()
    require("conform").setup({
      -- Configuration options for conform.nvim.
      -- conform.nvimの設定オプション。

      -- Disable auto-format on save (can be triggered manually or via autocmd).
      -- 保存時の自動フォーマットを無効化（手動またはautocmd経由でトリガー可能）。
      format_on_save = false,

      -- Formatters for specific file types.
      -- 特定のファイルタイプのフォーマッター。
      formatters_by_ft = {
        lua = { "stylua" }, -- Lua formatter.
        -- Luaフォーマッター。
        python = { "black" }, -- Python formatter.
        -- Pythonフォーマッター。
        javascript = { "prettierd", "prettier" }, -- JavaScript formatters.
        -- JavaScriptフォーマッター。
        typescript = { "prettierd", "prettier" }, -- TypeScript formatters.
        -- TypeScriptフォーマッター。
        javascriptreact = { "prettierd", "prettier" }, -- JSX formatters.
        -- JSXフォーマッター。
        typescriptreact = { "prettierd", "prettier" }, -- TSX formatters.
        -- TSXフォーマッター。
        vue = { "prettierd", "prettier" }, -- Vue formatters.
        -- Vueフォーマッター。
        json = { "prettierd", "prettier" }, -- JSON formatters.
        -- JSONフォーマッター。
        yaml = { "prettierd", "prettier" }, -- YAML formatters.
        -- YAMLフォーマッター。
        markdown = { "prettierd", "prettier" }, -- Markdown formatters.
        -- Markdownフォーマッター。
        html = { "prettierd", "prettier" }, -- HTML formatters.
        -- HTMLフォーマッター。
        css = { "prettierd", "prettier" }, -- CSS formatters.
        -- CSSフォーマッター。
      },

      -- Format options.
      -- フォーマットオプション。
      format_after_save = {
        lsp_fallback = true, -- Fallback to LSP formatting if formatter not available.
        -- フォーマッターが利用できない場合はLSPフォーマットにフォールバックします。
      },
    })
  end,
}