local dressing = {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = {
          -- Set to `false` to disable the vim.ui.input implementation
          enabled = false,
          -- Configure the display for vim.ui.input
          -- Options: 'getcmdline', 'editor', 'winbar',
          -- or a function that returns a table with `row` and `col` keys
          -- (the default is 'getcmdline')
          -- If you want to use the default vim.ui.input, set this to 'getcmdline'
          -- or remove this option entirely.
          -- For your case, we want to ensure it uses the command line.
          insert_mode = "getcmdline",
        },
        select = {
          -- Set to `false` to disable the vim.ui.select implementation
          enabled = true,
          -- Options: 'fzf', 'telescope', 'builtin', or a function
          -- (the default is 'builtin')
          -- If you want to use the default vim.ui.select, set this to 'builtin'
          -- or remove this option entirely.
          builtin = {
            -- These are the options passed to the builtin vim.ui.select.
            -- See `:h vim.ui.select()` for more details.
            -- For example, to use a floating window for select:
            -- prompt_position = "center",
            -- relative = "editor",
            -- win_options = {
            --   winblend = 0,
            --   border = "rounded",
            -- },
          },
        },
        notify = {
          -- Set to `false` to disable the vim.ui.notify implementation
          enabled = false,
        },
      })
    end
  }

return dressing
