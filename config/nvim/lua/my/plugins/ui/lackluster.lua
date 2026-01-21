-- This file configures lackluster.nvim, a customizable monochrome colorscheme for Neovim.
-- このファイルは、Neovim用のカスタマイズ可能なモノクロームカラースキームであるlackluster.nvimを設定します。

local config = function()
  -- Enable 24-bit RGB colors for better color support.
  -- より良いカラーサポートのために24ビットRGBカラーを有効化します。
  vim.opt.termguicolors = true

  -- Setup lackluster with custom color tweaks (optional).
  -- カスタムカラーの調整でlacklusterをセットアップします（オプション）。
  local lackluster = require("lackluster")

  lackluster.setup({
    tweak_color = {
      -- Overwrite default colors with hex codes or use "default".
      -- デフォルトの色を16進数コードで上書きするか、"default"を使用します。
      -- lack = "#aaaa77",
      -- orange = "default",
      -- red = "default",
    },
  })

  -- Apply the lackluster colorscheme.
  -- lacklusterカラースキームを適用します。
  vim.cmd.colorscheme("lackluster")

  -- Customize highlight groups if needed.
  -- 必要に応じてハイライトグループをカスタマイズします。
  vim.cmd([[
    hi WinSeparator guifg=#535353
    hi Visual ctermfg=159 ctermbg=23 guifg=#b3c3cc guibg=#384851
    hi DiffAdd guifg=#25be6a
    hi DiffDelete guifg=#ee5396
  ]])
end

local lackluster = {
  "slugbyte/lackluster.nvim",
  lazy = false,
  priority = 1000, -- Load early to ensure colorscheme is applied.
  config = config,
}

return lackluster
