-- This file configures satellite.nvim, which adds a decorated scrollbar to the window.
-- このファイルは、ウィンドウに装飾されたスクロールバーを追加するsatellite.nvimを設定します。

local satellite = {
  "lewis6991/satellite.nvim",
  config = function()
    require("satellite").setup({
      -- Configuration options for satellite.nvim.
      -- satellite.nvimの設定オプション。
      current_only = false, -- Show scrollbar for all windows, not just current.
      -- 現在のウィンドウだけでなく、すべてのウィンドウにスクロールバーを表示します。
      width = 2, -- Width of the scrollbar.
      -- スクロールバーの幅。
      handlers = {
        -- Handlers for different scrollbar marks.
        -- 異なるスクロールバーマークのハンドラ。
        -- Each handler must be a table with configuration options.
        -- 各ハンドラは設定オプションを持つテーブルである必要があります。
        search = {
          enable = true, -- Enable search result marks.
          -- 検索結果マークを有効化します。
        },
        gitsigns = {
          enable = true, -- Enable git signs marks (requires gitsigns.nvim).
          -- Gitサインのマークを有効化します（gitsigns.nvimが必要です）。
        },
        diagnostic = {
          enable = true, -- Enable diagnostic marks.
          -- 診断マークを有効化します。
        },
      },
    })
  end,
}

return satellite
