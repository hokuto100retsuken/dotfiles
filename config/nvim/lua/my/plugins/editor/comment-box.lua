-- This file configures comment-box.nvim, which clarifies comments by wrapping them in boxes or lines.
-- このファイルは、コメントをボックスやラインで囲んで明確にするcomment-box.nvimを設定します。

local comment_box = {
  "LudoPinelli/comment-box.nvim",
  config = function()
    require("comment-box").setup({
      -- Configuration options for comment-box.nvim.
      -- comment-box.nvimの設定オプション。
      doc_width = 80, -- Width of the comment box.
      -- コメントボックスの幅。
      box_width = 70, -- Width of the inner box.
      -- 内側のボックスの幅。
      borders = {
        -- Border characters for the comment box.
        -- コメントボックスの境界文字。
        top = "─",
        bottom = "─",
        left = "│",
        right = "│",
        top_left = "╭",
        top_right = "╮",
        bottom_left = "╰",
        bottom_right = "╯",
      },
    })
  end,
}

return comment_box
