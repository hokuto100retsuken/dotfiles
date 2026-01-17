local utils = require('my/utils')
local nmap = utils.keymaps.nmap

local toggleterm = {
    "akinsho/nvim-toggleterm.lua",
    config = function()
        local t = require("toggleterm")
        t.setup{
            size = 20,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = false,
            persist_size = true,
            direction = 'float',
            close_on_exit = true,
            shell = vim.o.shell,
        }

        -- Lazygit terminal
        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })

        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end
    end,
}

return toggleterm
