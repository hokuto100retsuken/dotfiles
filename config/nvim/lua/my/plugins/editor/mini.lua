return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    -- mini.pairs, mini.surround, mini.comment
    require('mini.pairs').setup()
    require('mini.surround').setup()
    require('mini.comment').setup()
  end,
}
