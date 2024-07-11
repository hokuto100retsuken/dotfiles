local opt = vim.opt

-- Set encoding options
opt.encoding = 'utf-8'                       -- Set the character encoding
opt.fileencoding = 'utf-8'                   -- Set the file encoding
opt.fileencodings = 'utf-8,euc-jp,shift-jis' -- Set the file encodings
-- opt.termencoding = 'utf-8'                   -- Set the terminal encoding

-- Set global options
local g = vim.g
g.mapleader = " "                   -- Set the leader key
g["markdown_recommended_style"] = 0 -- Disable the recommended style for markdown

-- Set various options
opt.breakindent = true                                                          -- Enable break indent
opt.number = false                                                              -- Disable line numbers
opt.incsearch = true                                                            -- Enable incremental search
opt.ignorecase = true                                                           -- Ignore case in search
opt.smartcase = true                                                            -- Enable smart case in search
opt.hlsearch = true                                                             -- Highlight search results
opt.autoindent = true                                                           -- Enable auto indent
opt.smartindent = true                                                          -- Enable smart indent
opt.virtualedit = "block"                                                       -- Enable virtual edit in block mode
opt.showtabline = 1                                                             -- Show the tab line
opt.tabstop = 2                                                                 -- Set the tab stop width
opt.shiftwidth = 2                                                              -- Set the shift width
opt.softtabstop = 2                                                             -- Set the soft tab stop width
opt.completeopt = 'menu,menuone,noselect'                                       -- Set the complete options
opt.laststatus = 3                                                              -- Set the last status line option
opt.scrolloff = 100                                                             -- Set the scroll off option
opt.cursorline = true                                                           -- Highlight the cursor line
opt.helplang = 'ja'                                                             -- Set the help language to Japanese
opt.autowrite = true                                                            -- Enable auto write
opt.swapfile = false                                                            -- Disable swap file
opt.diffopt = 'vertical,internal'                                               -- Set the diff options
opt.clipboard:append({ vim.fn.has('mac') == 1 and 'unnamed' or 'unnamedplus' }) -- Set the clipboard option
opt.grepprg = 'rg --vimgrep'                                                    -- Set the grep program
opt.grepformat = '%f:%l:%c:%m'                                                  -- Set the grep format
opt.mouse = {}                                                                  -- Disable mouse
