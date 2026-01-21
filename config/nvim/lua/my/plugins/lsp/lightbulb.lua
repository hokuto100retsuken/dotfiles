-- This file configures nvim-lightbulb, which displays a VSCode-style lightbulb icon when LSP code actions are available.
-- このファイルは、LSPコードアクションが利用可能な時にVSCodeスタイルの電球アイコンを表示するnvim-lightbulbを設定します。

local lightbulb = {
  "kosayoda/nvim-lightbulb",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("nvim-lightbulb").setup({
      -- Configuration options for nvim-lightbulb.
      -- nvim-lightbulbの設定オプション。
      ignore = {}, -- List of LSP clients to ignore.
      -- 無視するLSPクライアントのリスト。
      sign = {
        enabled = true, -- Enable the sign column icon.
        -- サインカラムのアイコンを有効化します。
        priority = 10, -- Priority of the sign.
        -- サインの優先度。
      },
      virtual_text = {
        enabled = false, -- Disable virtual text (use sign instead).
        -- 仮想テキストを無効化します（代わりにサインを使用）。
      },
      status_text = {
        enabled = false, -- Disable status text.
        -- ステータステキストを無効化します。
      },
    })

    -- Show lightbulb when code actions are available.
    -- コードアクションが利用可能な時に電球を表示します。
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = function()
        require("nvim-lightbulb").update_lightbulb()
      end,
    })
  end,
}

return lightbulb
