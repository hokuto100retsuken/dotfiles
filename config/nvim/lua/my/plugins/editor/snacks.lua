-- This file configures snacks.nvim, a collection of quality-of-life plugins for Neovim.
-- このファイルは、Neovim用のQoLプラグインのコレクションであるsnacks.nvimを設定します。

local snacks = {
  "folke/snacks.nvim",
  event = "VeryLazy",
  config = function()
    require("snacks").setup({
      -- Configuration options for snacks.nvim modules.
      -- snacks.nvimモジュールの設定オプション。

      -- Bigfile module: Optimizes Neovim's performance for large files.
      -- Bigfileモジュール: 大きなファイルに対するNeovimのパフォーマンスを最適化します。
      bigfile = {
        enabled = true, -- Enable bigfile optimization.
        -- bigfile最適化を有効化します。
        filesize = 2, -- File size threshold in MB.
        -- ファイルサイズの閾値（MB）。
      },

      -- Indent module: Shows indent guides.
      -- Indentモジュール: インデントガイドを表示します。
      indent = {
        enabled = true, -- Enable indent guides.
        -- インデントガイドを有効化します。
      },

      -- Scope module: Shows Treesitter-based scope detection.
      -- Scopeモジュール: Treesitterベースのスコープ検出を表示します。
      scope = {
        enabled = true, -- Enable scope detection.
        -- スコープ検出を有効化します。
      },

      -- Dashboard module: A beautiful startup screen.
      -- Dashboardモジュール: 美しいスタートアップ画面。
      dashboard = {
        enabled = true, -- Enable dashboard.
        -- ダッシュボードを有効化します。
      },

      -- Quickfile module: Renders files quickly before other plugins load.
      -- Quickfileモジュール: 他のプラグインが読み込まれる前にファイルを高速にレンダリングします。
      quickfile = {
        enabled = true, -- Enable quickfile.
        -- quickfileを有効化します。
      },
    })
  end,
}

return snacks
