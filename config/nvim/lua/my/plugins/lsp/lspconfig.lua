-- This file configures nvim-lspconfig, which provides configurations for Neovim's built-in LSP client.
-- このファイルは、Neovimの組み込みLSPクライアントの設定を提供するnvim-lspconfigを設定します。

local lspconfig = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "SmiteshP/nvim-navic", -- For code context display in winbar.
    -- winbarでコードコンテキストを表示するために使用します。
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local navic = require("nvim-navic")

    -- Function to set up LSP keymaps.
    -- LSPのキーマップを設定する関数。
    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, silent = true }

      -- Keymaps for LSP functions.
      -- LSP機能のキーマップ。
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, opts)

      -- Keymaps for diagnostics.
      -- 診断のキーマップ。
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

      -- Attach navic to LSP client for code context display.
      -- コードコンテキスト表示のためにnavicをLSPクライアントにアタッチします。
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
    end

    -- Enhanced LSP capabilities configuration.
    -- LSPの機能を拡張する設定。
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- TypeScript/JavaScript LSP configuration using Neovim 0.11+ native API.
    -- Neovim 0.11+のネイティブAPIを使用したTypeScript/JavaScript用のLSP設定。
    vim.lsp.config("ts_ls", {
      capabilities = capabilities,
      filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
      -- VueファイルでもTypeScript LSPを有効化
      -- Enable TypeScript LSP for Vue files as well
      settings = {
        typescript = {
          inlayHints = {
            enabled = true,
          },
        },
        javascript = {
          inlayHints = {
            enabled = true,
          },
        },
        vue = {
          inlayHints = {
            enabled = true,
          },
        },
      },
      on_attach = function(client, bufnr)
        -- Disable automatic formatting (use formatter plugin instead).
        -- 自動フォーマットを無効化します（代わりにフォーマッタープラグインを使用）。
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        -- Enable other LSP features.
        -- その他のLSP機能は有効化します。
        on_attach(client, bufnr)
      end,
    })

    -- Enable TypeScript/JavaScript LSP server.
    -- TypeScript/JavaScript LSPサーバーを有効化します。
    vim.lsp.enable("ts_ls")

    -- Lua LSP configuration using Neovim 0.11+ native API.
    -- Neovim 0.11+のネイティブAPIを使用したLua用のLSP設定。
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
      on_attach = on_attach,
    })

    -- Enable Lua LSP server.
    -- Lua LSPサーバーを有効化します。
    vim.lsp.enable("lua_ls")

    -- Diagnostic display configuration.
    -- 診断の表示設定。
    vim.diagnostic.config({
      virtual_text = {
        severity = {
          min = vim.diagnostic.severity.WARN,
        },
        source = "always",
        format = function(diagnostic)
          return string.format("%s: %s", diagnostic.source, diagnostic.message)
        end,
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    -- Diagnostic icon configuration.
    -- 診断アイコンの設定。
    local signs = {
      { name = "DiagnosticSignError", text = "✗" },
      { name = "DiagnosticSignWarn", text = "⚠" },
      { name = "DiagnosticSignHint", text = "➤" },
      { name = "DiagnosticSignInfo", text = "ℹ" },
    }

    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, {
        texthl = sign.name,
        text = sign.text,
        numhl = "",
      })
    end
  end,
}

return lspconfig
