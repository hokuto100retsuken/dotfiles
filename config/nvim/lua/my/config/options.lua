local opt = vim.opt
local g = vim.g

-- Encoding
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.fileencodings = 'utf-8,euc-jp,shift-jis'

-- Global variables
g.mapleader = " "
g["markdown_recommended_style"] = 0
g.python3_host_prog = '/usr/bin/python3'

-- General UI and behavior
opt.number = true           -- Show line numbers
opt.relativenumber = false  -- Disable relative line numbers
opt.mouse = 'a'             -- Enable mouse
opt.title = true            -- Set terminal title
opt.showcmd = true          -- Show command in status line
opt.cmdheight = 2           -- Command line height
opt.laststatus = 3          -- Always show status line
opt.showtabline = 2         -- Always show tab line
opt.termguicolors = true    -- Enable true colors
opt.signcolumn = 'yes'      -- Always show sign column
opt.hidden = true           -- Hide buffers instead of closing
opt.swapfile = false        -- Disable swap file
opt.winblend = 5            -- Float window transparency

-- Indentation and formatting
opt.autoindent = true       -- Enable auto indent
opt.smartindent = true      -- Enable smart indent
opt.expandtab = true        -- Use spaces instead of tabs
opt.shiftwidth = 2          -- Set the shift width
opt.tabstop = 2             -- Set the tab stop width
opt.smarttab = true         -- Smart tab
opt.breakindent = true      -- Enable break indent
opt.wrap = true             -- Wrap lines

-- Search
opt.hlsearch = true         -- Highlight search results
opt.incsearch = true        -- Enable incremental search
opt.ignorecase = true       -- Ignore case in search
opt.smartcase = true        -- Enable smart case in search

-- Scrolling
opt.scrolloff = 10          -- Lines of context around cursor

-- Command execution
opt.shell = 'zsh'           -- Set shell
opt.inccommand = 'split'    -- Live preview for :substitute

-- Completion
opt.updatetime = 300        -- Faster completion
opt.completeopt = 'menu,menuone,noselect' -- Set the complete options

-- Clipboard
opt.clipboard:append({ vim.fn.has('mac') == 1 and 'unnamed' or 'unnamedplus' }) -- Set the clipboard option

-- Other
opt.cursorline = true       -- Highlight the cursor line
opt.helplang = 'ja,en'      -- Set the help language
opt.autowrite = true        -- Enable auto write
opt.diffopt = 'vertical,internal' -- Set the diff options
opt.grepprg = 'rg --vimgrep' -- Set the grep program
opt.grepformat = '%f:%l:%c:%m' -- Set the grep format
opt.virtualedit = "block" -- Enable virtual edit in block mode

-- Ensure command line appears at bottom
opt.cmdheight = 2           -- Command line height
opt.laststatus = 3          -- Always show status line
opt.showcmd = true          -- Show command in status line

-- Disable floating command line
g.ui_notifications_enabled = false
