-- This file configures nightfox.nvim, a highly customizable theme for vim and neovim.
-- このファイルは、vimとneovim用の高度にカスタマイズ可能なテーマであるnightfox.nvimを設定します。

local config = function()
  vim.opt.termguicolors = true

  -- Replace carbonfox's palette with Ghostty's "12-bit Rainbow" theme colors.
  -- Ghostty のテーマ「12-bit Rainbow」の色で carbonfox のパレットを置き換えます。
  -- base は ANSI の通常色(0-7)、bright は明るい色(8-15)。orange / pink は ANSI に無いので近い色を充てる。
  -- 背景とのコントラスト比が 4.5 未満の色は、色相を保ったまま 4.5 まで明るくしている（元の色をコメントに残す）。
  local C = require("nightfox.lib.color")
  local function shade(base, bright)
    return { base = base, bright = bright, dim = C(base):brighten(-15):to_css() }
  end
  local bg = C("#040404")
  local fg = C("#feffff")
  local rainbow = {
    black   = shade("#000000", "#685656"),
    red     = shade("#d33f6a", "#c06060"), -- base: #a03050
    green   = shade("#40d080", "#90d050"),
    yellow  = shade("#e0d000", "#e0d000"),
    blue    = shade("#3a75d6", "#00b0c0"), -- base: #3060b0
    magenta = shade("#9c4ee9", "#d41bba"), -- base: #603090, bright: #801070
    cyan    = shade("#0090c0", "#20b0c0"),
    white   = shade("#dbded8", "#ffffff"),
    orange  = shade("#e09040", "#e0d000"),
    pink    = shade("#c06060", "#d33f6a"), -- bright: #a03050

    comment = "#777777", -- bg と fg を 4:6 で混ぜた #686868 を明るくしたもの

    bg0 = bg:brighten(-4):to_css(),
    bg1 = bg:to_css(),
    bg2 = bg:brighten(6):to_css(),
    bg3 = bg:brighten(12):to_css(),
    bg4 = bg:brighten(24):to_css(),

    fg0 = fg:brighten(6):to_css(),
    fg1 = fg:to_css(),
    fg2 = fg:brighten(-24):to_css(),
    fg3 = fg:brighten(-48):to_css(),

    sel0 = "#303030", -- カーソル行(bg3)より明るくして選択範囲を見分けやすくする
    sel1 = "#606060", -- Ghostty の selection-background と同じ
  }

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
    palettes = {
      carbonfox = rainbow,
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
