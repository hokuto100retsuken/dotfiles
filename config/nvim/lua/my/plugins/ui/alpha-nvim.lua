return {
  'goolord/alpha-nvim',
  event = "VimEnter",
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    -- Header (Pixel art style NEOVIM logo)
    dashboard.section.header.val = {
      "",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
      "",
    }
    
    -- Set header highlight to cyan for pixel art effect
    dashboard.section.header.opts.hl = "Type"
    
    -- Create custom highlight for cyan color before alpha setup
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#00ffff", bold = true })
    dashboard.section.header.opts.hl = "AlphaHeader"

    -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
      dashboard.button("n", "  New File", ":ene<CR>"),
      dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
      dashboard.button("g", "  Live Grep", ":Telescope live_grep<CR>"),
      dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }

    -- Footer
    local function footer()
      local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
      local version = vim.version()
      local nvim_version = string.format("v%d.%d.%d", version.major, version.minor, version.patch)
      return datetime .. "   " .. nvim_version
    end

    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = "Comment"

    alpha.setup(dashboard.opts)

    -- Disable statusline and tabline on alpha buffer
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.laststatus = 0
        vim.opt_local.showtabline = 0
      end,
    })
  end
}