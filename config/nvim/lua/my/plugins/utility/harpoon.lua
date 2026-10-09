-- harpoon: 作業中のファイル数個を固定スロットに置き、番号で直行するためのプラグイン。
-- bufferline は開いた順に並びが動くので、番号ジャンプはこちらが担当する。
local harpoon = {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")
        local keymap = vim.keymap

        -- 登録とメニュー
        keymap.set("n", "<leader>hm", mark.add_file, { desc = "Mark file with harpoon" })
        keymap.set("n", "<leader>hh", ui.toggle_quick_menu, { desc = "Harpoon menu" })
        keymap.set("n", "<leader>hd", mark.rm_file, { desc = "Remove file from harpoon" })
        keymap.set("n", "<leader>hc", mark.clear_all, { desc = "Clear all harpoon marks" })

        -- 前後移動
        keymap.set("n", "<leader>hn", ui.nav_next, { desc = "Go to next harpoon mark" })
        keymap.set("n", "<leader>hp", ui.nav_prev, { desc = "Go to previous harpoon mark" })

        -- 固定スロットへ直行
        for i = 1, 4 do
            keymap.set("n", "<leader>" .. i, function()
                ui.nav_file(i)
            end, { desc = "Harpoon file " .. i })
        end
    end,
}

return harpoon
