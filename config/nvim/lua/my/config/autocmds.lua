local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Example: Auto-save on focus lost
-- autocmd("VimLeavePre", { group = augroup("MyAutoCommands", {}), command = "wa" })
