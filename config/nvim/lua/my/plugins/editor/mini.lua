return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    -- mini.pairs, mini.surround, mini.comment
    require('mini.pairs').setup()
    require('mini.surround').setup()
    require('mini.comment').setup({
      options = {
        custom_commentstring = function()
          local ok, cs = pcall(require('ts_context_commentstring').calculate_commentstring)
          if ok and cs then return cs end
          return vim.bo.commentstring
        end,
      },
    })
  end,
}
