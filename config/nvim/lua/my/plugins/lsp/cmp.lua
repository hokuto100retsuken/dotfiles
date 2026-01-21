-- This file configures nvim-cmp, a completion engine for Neovim.
-- このファイルは、Neovim用の補完エンジンであるnvim-cmpを設定します。

local cmp = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- LSP completion source.
    -- LSP補完ソース。
    "hrsh7th/cmp-buffer", -- Buffer completion source.
    -- バッファ補完ソース。
    "hrsh7th/cmp-path", -- Path completion source.
    -- パス補完ソース。
    "saadparwaiz1/cmp_luasnip", -- LuaSnip completion source.
    -- LuaSnip補完ソース。
    "L3MON4D3/LuaSnip", -- Snippet engine.
    -- スニペットエンジン。
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Completion source configuration.
    -- 補完ソースの設定。
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        -- Scroll documentation up.
        -- ドキュメントを上にスクロール。
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        -- Scroll documentation down.
        -- ドキュメントを下にスクロール。
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        -- Trigger completion.
        -- 補完をトリガー。
        ["<C-Space>"] = cmp.mapping.complete(),
        -- Abort completion.
        -- 補完を中止。
        ["<C-e>"] = cmp.mapping.abort(),
        -- Confirm selection.
        -- 選択を確認。
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        -- Navigate to next item or expand/jump snippet.
        -- 次の項目に移動するか、スニペットを展開/ジャンプ。
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        -- Navigate to previous item or jump snippet backward.
        -- 前の項目に移動するか、スニペットを後方にジャンプ。
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        -- Priority sources (shown first).
        -- 優先ソース（最初に表示）。
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        -- Secondary sources (shown after priority sources).
        -- セカンダリソース（優先ソースの後に表示）。
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        format = function(entry, item)
          -- Icons for different completion sources.
          -- 異なる補完ソースのアイコン。
          local icons = {
            nvim_lsp = "LSP",
            luasnip = "Snip",
            buffer = "Buf",
            path = "Path",
          }
          item.menu = icons[entry.source.name] or entry.source.name
          return item
        end,
      },
      -- Performance optimization.
      -- パフォーマンス最適化。
      performance = {
        debounce = 60, -- Debounce time in milliseconds.
        -- デバウンス時間（ミリ秒）。
        throttle = 30, -- Throttle time in milliseconds.
        -- スロットル時間（ミリ秒）。
        fetching_timeout = 500, -- Fetching timeout in milliseconds.
        -- フェッチタイムアウト（ミリ秒）。
      },
    })
  end,
}

return cmp
