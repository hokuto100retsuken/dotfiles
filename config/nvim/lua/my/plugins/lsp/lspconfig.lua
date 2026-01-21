local lspconfig = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        -- LSPのキーマップを設定する関数
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }

            -- キーマップ
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

            -- 診断のキーマップ
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
        end

        -- LSPの機能を拡張する設定
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- TypeScript/JavaScript用のLSP設定（Neovim 0.11+の新しいAPI）
        vim.lsp.config("ts_ls", {
            capabilities = capabilities,
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
            },
            on_attach = function(client, bufnr)
                -- 自動フォーマットを無効化
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
                -- その他のLSP機能は有効化
                on_attach(client, bufnr)
            end,
        })

        -- LSPサーバーを有効化
        vim.lsp.enable("ts_ls")

        -- 診断の表示設定
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

        -- 診断アイコンの設定
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
