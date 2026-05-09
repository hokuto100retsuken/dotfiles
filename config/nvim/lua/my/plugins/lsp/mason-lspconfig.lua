-- This file configures mason-lspconfig, which bridges mason.nvim with nvim-lspconfig.
-- このファイルは、mason.nvimとnvim-lspconfigを橋渡しするmason-lspconfigを設定します。

local mason_lspconfig = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason-lspconfig").setup({
      -- List of LSP servers to ensure are installed.
      -- インストールを保証するLSPサーバーのリスト。
      ensure_installed = {
        "ts_ls",        -- TypeScript/JavaScript
        "lua_ls",       -- Lua
        "gopls",        -- Go
        "intelephense", -- PHP
      },
      -- Automatically install missing servers.
      -- 不足しているサーバーを自動的にインストールします。
      automatic_installation = true,
    })
  end,
}

return mason_lspconfig
