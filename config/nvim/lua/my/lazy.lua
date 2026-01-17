-- This file is for setting up lazy.nvim, the plugin manager for Neovim.
-- このファイルはNeovimのプラグインマネージャーであるlazy.nvimのセットアップを行います。

-- Bootstrap lazy.nvim: Automatically install lazy.nvim if it's not already installed.
-- lazy.nvimのブートストラップ: まだインストールされていない場合に自動でインストールします。
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

-- Add lazy.nvim to the runtime path.
-- lazy.nvimをランタイムパスに追加します。
vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim with plugins.
-- プラグインを指定してlazy.nvimをセットアップします。
require("lazy").setup({
  spec = {
    -- Import all plugin configurations from their respective category subdirectories.
    -- 各カテゴリのサブディレクトリから、全てのプラグイン設定をインポートします。
    { import = "my.plugins.ui" },
    { import = "my.plugins.editor" },
    { import = "my.plugins.git" },
    { import = "my.plugins.lsp" },
    { import = "my.plugins.utility" },
  },

  -- Configure lazy.nvim's options.
  -- lazy.nvim自体のオプションを設定します。
  change_detection = {
    -- Automatically check for plugin updates.
    -- プラグインの更新を自動でチェックします。
    enabled = true,
    -- Don't notify about updates, as we can check them manually via the interface.
    -- 更新はUIから確認できるので、通知は無効にします。
    notify = false,
  },

  -- Configure the UI for the loading screen.
  -- ローディング画面のUIを設定します。
  ui = {
    -- Use a thicker border for the loading window.
    -- ローディングウィンドウのボーダーを太くします。
    border = "double",
  },
})
