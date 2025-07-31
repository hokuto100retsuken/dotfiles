return {
  'Exafunction/Codeium.vim',
  config = function()
    vim.g.codeium_disable_bindings = 1
    vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Cycle'](1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-z>', function() return vim.fn['codeium#Cycle'](-1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-c>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  end
}