-- This file defines autocommands, which are commands that are automatically
-- executed when certain events occur (e.g., saving a file, changing filetype).
-- For more information, see :help autocommand

local augroup = vim.api.nvim_create_augroup -- Create a new augroup
local autocmd = vim.api.nvim_create_autocmd   -- Create a new autocommand

-- Define a group for user-defined autocommands
local my_autocommands = augroup("MyAutoCommands", { clear = true })

-- ┃ Example Autocommands ┃
-- Add more autocommands here as needed.

-- Example: Ensure file ends with a newline on save
-- autocmd("BufWritePre", {
--   group = my_autocommands,
--   pattern = "*",
--   command = "lua vim.cmd('normal! G$x$a<CR><ESC>')",
--   desc = "Ensure file ends with a newline on save",
-- })

-- Example: Automatically enter insert mode when opening a terminal
-- autocmd("TermOpen", {
--   group = my_autocommands,
--   pattern = "*",
--   command = "startinsert",
--   desc = "Enter insert mode when opening a terminal",
-- })

-- Example: Set options for specific file types
-- autocmd("FileType", {
--   group = my_autocommands,
--   pattern = "markdown,txt",
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.spell = true
--   end,
--   desc = "Enable wrap and spellcheck for text files",
-- })
