local treesitter_textobjects = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = true,
    init = function()
        -- 組み込み ftplugin のバッファローカルな ]m などが、下のグローバルな割り当てを上書きしないようにする
        vim.g.no_plugin_maps = true
    end,
    config = function()
        require("nvim-treesitter-textobjects").setup({
            select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
            },
            move = {
                set_jumps = true, -- whether to set jumps in the jumplist
            },
        })

        local select = require("nvim-treesitter-textobjects.select")
        local swap = require("nvim-treesitter-textobjects.swap")
        local move = require("nvim-treesitter-textobjects.move")

        -- You can use the capture groups defined in textobjects.scm
        local selects = {
            { "a=", "@assignment.outer", "Select outer part of an assignment" },
            { "i=", "@assignment.inner", "Select inner part of an assignment" },
            { "l=", "@assignment.lhs", "Select left hand side of an assignment" },
            { "r=", "@assignment.rhs", "Select right hand side of an assignment" },

            -- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
            { "a:", "@property.outer", "Select outer part of an object property" },
            { "i:", "@property.inner", "Select inner part of an object property" },
            { "l:", "@property.lhs", "Select left part of an object property" },
            { "r:", "@property.rhs", "Select right part of an object property" },

            { "aa", "@parameter.outer", "Select outer part of a parameter/argument" },
            { "ia", "@parameter.inner", "Select inner part of a parameter/argument" },

            { "ai", "@conditional.outer", "Select outer part of a conditional" },
            { "ii", "@conditional.inner", "Select inner part of a conditional" },

            { "al", "@loop.outer", "Select outer part of a loop" },
            { "il", "@loop.inner", "Select inner part of a loop" },

            { "af", "@call.outer", "Select outer part of a function call" },
            { "if", "@call.inner", "Select inner part of a function call" },

            { "am", "@function.outer", "Select outer part of a method/function definition" },
            { "im", "@function.inner", "Select inner part of a method/function definition" },

            { "ac", "@class.outer", "Select outer part of a class" },
            { "ic", "@class.inner", "Select inner part of a class" },
        }
        for _, s in ipairs(selects) do
            vim.keymap.set({ "x", "o" }, s[1], function()
                select.select_textobject(s[2], "textobjects")
            end, { desc = s[3] })
        end

        local swaps = {
            { "<leader>na", "swap_next", "@parameter.inner", "Swap parameter with next" },
            { "<leader>n:", "swap_next", "@property.outer", "Swap object property with next" },
            { "<leader>nm", "swap_next", "@function.outer", "Swap function with next" },
            { "<leader>pa", "swap_previous", "@parameter.inner", "Swap parameter with prev" },
            { "<leader>p:", "swap_previous", "@property.outer", "Swap object property with prev" },
            { "<leader>pm", "swap_previous", "@function.outer", "Swap function with previous" },
        }
        for _, s in ipairs(swaps) do
            vim.keymap.set("n", s[1], function()
                swap[s[2]](s[3])
            end, { desc = s[4] })
        end

        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        local moves = {
            { "]f", "goto_next_start", "@call.outer", "textobjects", "Next function call start" },
            { "]m", "goto_next_start", "@function.outer", "textobjects", "Next method/function def start" },
            { "]c", "goto_next_start", "@class.outer", "textobjects", "Next class start" },
            { "]i", "goto_next_start", "@conditional.outer", "textobjects", "Next conditional start" },
            { "]l", "goto_next_start", "@loop.outer", "textobjects", "Next loop start" },
            { "]s", "goto_next_start", "@local.scope", "locals", "Next scope" },
            { "]z", "goto_next_start", "@fold", "folds", "Next fold" },

            { "]F", "goto_next_end", "@call.outer", "textobjects", "Next function call end" },
            { "]M", "goto_next_end", "@function.outer", "textobjects", "Next method/function def end" },
            { "]C", "goto_next_end", "@class.outer", "textobjects", "Next class end" },
            { "]I", "goto_next_end", "@conditional.outer", "textobjects", "Next conditional end" },
            { "]L", "goto_next_end", "@loop.outer", "textobjects", "Next loop end" },

            { "[f", "goto_previous_start", "@call.outer", "textobjects", "Prev function call start" },
            { "[m", "goto_previous_start", "@function.outer", "textobjects", "Prev method/function def start" },
            { "[c", "goto_previous_start", "@class.outer", "textobjects", "Prev class start" },
            { "[i", "goto_previous_start", "@conditional.outer", "textobjects", "Prev conditional start" },
            { "[l", "goto_previous_start", "@loop.outer", "textobjects", "Prev loop start" },

            { "[F", "goto_previous_end", "@call.outer", "textobjects", "Prev function call end" },
            { "[M", "goto_previous_end", "@function.outer", "textobjects", "Prev method/function def end" },
            { "[C", "goto_previous_end", "@class.outer", "textobjects", "Prev class end" },
            { "[I", "goto_previous_end", "@conditional.outer", "textobjects", "Prev conditional end" },
            { "[L", "goto_previous_end", "@loop.outer", "textobjects", "Prev loop end" },
        }
        for _, m in ipairs(moves) do
            vim.keymap.set({ "n", "x", "o" }, m[1], function()
                move[m[2]](m[3], m[4])
            end, { desc = m[5] })
        end

        local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

        -- vim way: ; goes to the direction you were moving.
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
}

return treesitter_textobjects
