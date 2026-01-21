local mason_lspconfig = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "ts_ls",
                "lua_ls",
            },
            automatic_installation = true,
        })
    end,
}

return mason_lspconfig
