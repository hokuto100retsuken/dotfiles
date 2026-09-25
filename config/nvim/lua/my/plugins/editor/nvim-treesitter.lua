local nvim_treesitter = {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        -- main ブランチは遅延読み込みに対応していない
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "windwp/nvim-ts-autotag",
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            -- ensure these language parsers are installed (no-op if already installed)
            require("nvim-treesitter").install({
                "json",
                "javascript",
                "typescript",
                "tsx",
                "vue",
                "yaml",
                "toml",
                "html",
                "css",
                "prisma",
                "markdown",
                "markdown_inline",
                "svelte",
                "graphql",
                "sql",
                "bash",
                "fish",
                "lua",
                "vim",
                "python",
                "ruby",
                "go",
                "rust",
                "php",
                "java",
                "c",
                "cpp",
                "dockerfile",
                "gitignore",
                "diff",
                "regex",
                "query",
            })

            -- enable syntax highlighting and indentation for filetypes that have a parser
            -- パーサーがあるファイルタイプでハイライトとインデントを有効化
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("my_treesitter", { clear = true }),
                callback = function(args)
                    if not pcall(vim.treesitter.start, args.buf) then
                        return
                    end
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })

            -- expand / shrink selection by syntax node (Nvim built-in v_an / v_in)
            -- 構文ノード単位で選択範囲を広げる・狭める（Nvim 組み込みの v_an / v_in）
            vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start node selection" })
            vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Expand node selection" })
            vim.keymap.set("x", "<bs>", "in", { remap = true, desc = "Shrink node selection" })

            -- enable autotagging (w/ nvim-ts-autotag plugin)
            require("nvim-ts-autotag").setup()

            -- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
            require('ts_context_commentstring').setup {
                enable_autocmd = false,
            }
        end,
    },
}

return nvim_treesitter
