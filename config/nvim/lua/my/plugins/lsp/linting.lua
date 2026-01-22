local linting = {
    "mfussenegger/nvim-lint",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            javascript = { "eslint_d", "eslint" }, -- Fallback to eslint if eslint_d is not available
            -- eslint_dが利用できない場合はeslintにフォールバック
            typescript = { "eslint_d", "eslint" },
            javascriptreact = { "eslint_d", "eslint" },
            typescriptreact = { "eslint_d", "eslint" },
            vue = { "eslint_d", "eslint" }, -- VueファイルでもESLintを使用
            -- Use ESLint for Vue files as well
            svelte = { "eslint_d", "eslint" },
            python = { "pylint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}

return linting
