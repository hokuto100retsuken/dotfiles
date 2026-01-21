-- This file configures flash.nvim, which provides enhanced navigation and motion using search labels.
-- このファイルは、検索ラベルを使用した拡張ナビゲーションとモーションを提供するflash.nvimを設定します。

local flash = {
  "folke/flash.nvim",
  event = "VeryLazy",
  config = function()
    require("flash").setup({
      -- Configuration options for flash.nvim.
      -- flash.nvimの設定オプション。
      labels = "asdghklqwertyuiopzxcvbnmfj", -- Characters to use for labels.
      -- ラベルに使用する文字。
      search = {
        -- Search configuration.
        -- 検索設定。
        mode = "fuzzy", -- Search mode: "exact", "search", "fuzzy".
        -- 検索モード: "exact", "search", "fuzzy"。
        wrap = {
          enabled = true, -- Wrap around when searching.
          -- 検索時に折り返します。
        },
      },
      label = {
        -- Label display configuration.
        -- ラベル表示設定。
        uppercase = false, -- Use lowercase labels.
        -- 小文字のラベルを使用します。
        rainbow = {
          enabled = true, -- Enable rainbow colors for labels.
          -- ラベルにレインボーカラーを有効化します。
          shade = 5, -- Shade level for rainbow colors.
          -- レインボーカラーのシェードレベル。
        },
      },
      modes = {
        -- Mode-specific configurations.
        -- モード固有の設定。
        char = {
          enabled = true, -- Enable char mode.
          -- 文字モードを有効化します。
          keys = { "f", "F" }, -- Keys to trigger char mode.
          -- 文字モードをトリガーするキー。
        },
        search = {
          enabled = true, -- Enable search mode.
          -- 検索モードを有効化します。
        },
      },
    })

    -- Keymaps for flash.nvim.
    -- flash.nvimのキーマップ。
    local keymap = vim.keymap

    -- Flash search (forward).
    -- Flash検索（前方）。
    keymap.set({ "n", "x", "o" }, "s", function()
      require("flash").jump()
    end, { desc = "Flash jump" })

    -- Flash search (backward).
    -- Flash検索（後方）。
    keymap.set({ "n", "x", "o" }, "S", function()
      require("flash").treesitter()
    end, { desc = "Flash treesitter" })

    -- Flash treesitter search.
    -- Flash treesitter検索。
    keymap.set({ "o", "x" }, "r", function()
      require("flash").remote()
    end, { desc = "Flash remote" })
  end,
}

return flash
