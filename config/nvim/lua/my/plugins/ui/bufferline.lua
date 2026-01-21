-- This file configures bufferline.nvim, a snazzy buffer line for Neovim.
-- このファイルは、Neovim用の洗練されたバッファラインであるbufferline.nvimを設定します。

local bufferline = {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup({
      options = {
        -- Show buffer numbers.
        -- バッファ番号を表示します。
        numbers = "ordinal",
        -- Use nvim-web-devicons for file icons.
        -- ファイルアイコンにnvim-web-deviconsを使用します。
        show_buffer_icons = true,
        -- Show buffer close icons.
        -- バッファを閉じるアイコンを表示します。
        show_close_icon = true,
        -- Show buffer separators.
        -- バッファのセパレータを表示します。
        separator_style = "thin",
        -- Always show tabline.
        -- 常にタブラインを表示します。
        always_show_bufferline = true,
      },
    })
  end,
}

return bufferline
