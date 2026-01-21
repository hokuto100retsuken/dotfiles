local luasnip = {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local luasnip = require("luasnip")

        -- VSCodeスタイルのスニペットを読み込む
        require("luasnip.loaders.from_vscode").lazy_load()

        -- スニペットのキーマップ
        vim.keymap.set({ "i", "s" }, "<C-l>", function()
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<C-h>", function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { silent = true })
    end,
}

return luasnip 