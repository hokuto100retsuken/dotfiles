-- This file configures vim-illuminate, which automatically highlights other uses of the word under the cursor.
-- このファイルは、カーソル下の単語の他の使用箇所を自動的にハイライトするvim-illuminateを設定します。

local illuminate = {
  "RRethy/vim-illuminate",
  config = function()
    require("illuminate").configure({
      -- Configuration options for vim-illuminate.
      -- vim-illuminateの設定オプション。
      delay = 200, -- Delay before highlighting (in milliseconds).
      -- ハイライトするまでの遅延（ミリ秒）。
      under_cursor = true, -- Highlight the word under the cursor.
      -- カーソル下の単語をハイライトします。
      large_file_cutoff = 2000, -- Don't highlight in files larger than this (in lines).
      -- これより大きいファイルではハイライトしません（行数）。
      large_file_overrides = {
        -- Override settings for large files.
        -- 大きなファイルの設定を上書きします。
        providers = { "lsp" },
      },
    })
  end,
}

return illuminate
