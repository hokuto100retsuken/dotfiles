local config = function()
  vim.g['copilot_no_tab_map'] = 1
  vim.api.nvim_set_keymap('i', '<Plug>(vimrc:copilot-dummy-map)', 'copilot#Accept("\\<Tab>")', { expr = true })
end

local copilot = {
  'github/copilot.vim',
  event = { 'BufRead', 'BufNewFile' },
  config = config
}

return copilot