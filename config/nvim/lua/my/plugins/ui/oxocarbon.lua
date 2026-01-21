-- This file configures oxocarbon.nvim, a dark and light Neovim theme written in fennel, inspired by IBM Carbon.
-- このファイルは、IBM CarbonにインスパイアされたFennelで書かれたダーク/ライトNeovimテーマであるoxocarbon.nvimを設定します。

local config = function()
  vim.opt.termguicolors = true
  vim.opt.background = "dark" -- Set background to dark (or "light" for light theme).
  -- 背景をダークに設定します（ライトテーマの場合は"light"を指定します）。
  vim.cmd.colorscheme("oxocarbon") -- Apply oxocarbon colorscheme.
  -- oxocarbonカラースキームを適用します。
end

local oxocarbon = {
  "nyoom-engineering/oxocarbon.nvim",
  lazy = false,
  priority = 1000, -- Load early to ensure colorscheme is applied.
  -- カラースキームが適用されるように早期に読み込みます。
  config = config,
}

return oxocarbon
