-- This file configures nightfox.nvim, a highly customizable theme for vim and neovim.
-- このファイルは、vimとneovim用の高度にカスタマイズ可能なテーマであるnightfox.nvimを設定します。

local config = function()
  vim.opt.termguicolors = true
  
  -- Configure nightfox with default options.
  -- デフォルトオプションでnightfoxを設定します。
  require("nightfox").setup({
    options = {
      -- Compiled file's destination location
      -- コンパイル済みファイルの保存先
      compile_path = vim.fn.stdpath("cache") .. "/nightfox",
      compile_file_suffix = "_compiled",
      transparent = false,     -- Disable setting background / 背景の設定を無効化
      terminal_colors = true,  -- Set terminal colors / ターミナルカラーを設定
      dim_inactive = false,    -- Non focused panes set to alternative background / 非フォーカスパネルを代替背景に設定
      module_default = true,   -- Default enable value for modules / モジュールのデフォルト有効値
      styles = {
        comments = "NONE",
        conditionals = "NONE",
        constants = "NONE",
        functions = "NONE",
        keywords = "NONE",
        numbers = "NONE",
        operators = "NONE",
        strings = "NONE",
        types = "NONE",
        variables = "NONE",
      },
    },
  })
  
  -- Apply carbonfox colorscheme.
  -- carbonfoxカラースキームを適用します。
  -- This must be done before lualine setup according to nightfox.nvim documentation.
  -- nightfox.nvimのドキュメントによると、これはlualineのsetupの前に実行する必要があります。
  vim.cmd.colorscheme("carbonfox")
end

local nightfox = {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000, -- Load early to ensure colorscheme is applied.
  -- カラースキームが適用されるように早期に読み込みます。
  config = config,
}

return nightfox
