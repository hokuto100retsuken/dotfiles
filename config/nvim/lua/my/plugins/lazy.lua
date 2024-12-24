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

vim.opt.rtp:prepend(lazypath)

local plugins = {}
local pluginList = require('my/plugins/_list')

for _, plugin in ipairs(pluginList) do
  table.insert(plugins, require('my/plugins/' .. plugin))
end

require("lazy").setup(plugins)
