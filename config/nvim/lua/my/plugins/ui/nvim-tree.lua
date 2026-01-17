-- This file configures nvim-tree, a file explorer plugin for Neovim.
-- It provides a tree-like view of the filesystem, allowing for easy navigation and file operations.
-- For more information, see: https://github.com/nvim-tree/nvim-tree.lua
-- このファイルは、Neovim用のファイルエクスプローラープラグインであるnvim-treeを設定します。
-- ファイルシステムをツリー形式で表示し、簡単なナビゲーションとファイル操作を可能にします。

return {
  "nvim-tree/nvim-tree.lua",

  -- Dependencies: nvim-tree requires nvim-web-devicons for displaying file icons.
  -- 依存関係: nvim-treeはファイルアイコンの表示のためにnvim-web-deviconsを必要とします。
  dependencies = { "nvim-tree/nvim-web-devicons" },

  -- Configuration function for nvim-tree
  -- nvim-treeの設定関数
  config = function()
    local nvimtree = require("nvim-tree")

    -- Disable Netrw (default Neovim file explorer)
    -- 組み込みのファイルエクスプローラーNetrwを無効化します。
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Setup nvim-tree with custom options
    -- nvim-treeをカスタムオプションで設定します。
    nvimtree.setup({
      -- View options for the tree
      -- ツリービューの表示オプション
      view = {
        width = 35,             -- Set the width of the nvim-tree window
        relativenumber = true,  -- Show relative line numbers in nvim-tree
      },
      -- Renderer options for icons and indent markers
      -- アイコンとインデントマーカーのレンダリングオプション
      renderer = {
        indent_markers = {
          enable = true,        -- Enable indent markers
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- Icon for closed folder
              arrow_open = "",   -- Icon for open folder
            },
          },
        },
      },
      -- Actions related to file operations
      -- ファイル操作に関連するアクション
      actions = {
        open_file = {
          window_picker = {
            enable = false,     -- Disable window picker when opening files
          },
        },
      },
      -- Custom file filtering rules
      -- カスタムファイルフィルタリングルール
      filters = {
        custom = { ".DS_Store", "thumbs.db" }, -- Add more files/patterns to ignore
      },
      -- Git integration settings
      -- Git連携設定
      git = {
        ignore = false,         -- Do not ignore gitignored files in nvim-tree
      },
      -- Other options can be added here
      -- その他のオプションはここに追加できます
    })

    -- Keymaps for nvim-tree
    -- nvim-treeのキーマップ
    local keymap = vim.keymap
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })                 -- ファイルエクスプローラーの表示/非表示を切り替える
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- 現在のファイルの場所でファイルエクスプローラーを開く/閉じる
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })           -- ファイルエクスプローラーを閉じる（全てのフォルダを折りたたむ）
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })              -- ファイルエクスプローラーを更新する
  end,
}