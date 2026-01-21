-- This file configures modes.nvim, which provides prismatic line decorations that change based on the current editor mode.
-- このファイルは、現在のエディタモードに応じて色が変わるプリズム風のライン装飾を提供するmodes.nvimを設定します。

local modes = {
  "mvllow/modes.nvim",
  config = function()
    require("modes").setup({
      -- Configuration options for modes.nvim.
      -- modes.nvimの設定オプション。
      colors = {
        copy = "#f5c359",
        delete = "#c75c6a",
        insert = "#266d6a",
        visual = "#c18a6e",
      },
      -- Line opacity settings.
      -- ラインの不透明度設定。
      line_opacity = 0.15,
    })
  end,
}

return modes
