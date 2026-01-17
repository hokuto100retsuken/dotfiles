-- This file configures Telescope, a highly extendable fuzzy finder over lists.
-- Telescope can be used to find files, grep, search help pages, and much more.
-- For more information, see: https://github.com/nvim-telescope/telescope.nvim
-- このファイルは、Telescopeという強力なファジーファインダーを設定します。
-- Telescopeはファイル検索、grep検索、ヘルプページの検索など、多岐にわたる用途に使用できます。

return {
  'nvim-telescope/telescope.nvim',

  -- These are the plugins that Telescope depends on
  -- Telescopeが依存するプラグイン
  dependencies = {
    -- Required dependency for Telescope
    -- Telescopeの必須依存プラグイン
    'nvim-lua/plenary.nvim',
    -- Used to improve the UI of Telescope pickers
    -- TelescopeのピッカーUIを改善するために使用されます
    'nvim-telescope/telescope-ui-select.nvim',
    -- egrepify integration
    -- egrepifyとの統合
    'nvim-telescope/telescope-egrepify.nvim',
  },

  -- This function is executed when the plugin is initialized.
  -- It sets up the keymappings for Telescope.
  -- この関数はプラグインの初期化時に実行されます。
  -- Telescopeのキーマッピングを設定します。
  init = function()
    -- `my.utils`から`nmap`関数を取得します。キーマップの定義に使用されます。
    local nmap = require('my.utils').keymaps.nmap
    -- Telescopeの組み込み関数を取得します。
    local builtin = require('telescope.builtin')

    -- Keymaps for finding things
    -- 検索機能のキーマップ
    nmap('<Leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' }) -- ファイルを検索
    nmap('<Leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' }) -- Grepで検索
    nmap('<Leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' }) -- バッファを検索
    nmap('<Leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' }) -- ヘルプタグを検索
    nmap('<Leader>fo', builtin.oldfiles, { desc = '[F]ind [O]ld Files' }) -- 最近開いたファイルを検索

    -- Keymaps for Git
    -- Git関連機能のキーマップ
    nmap('<Leader>fs', builtin.git_status, { desc = '[F]ind [S]tatus (Git)' }) -- Gitステータスを検索

    -- Other keymaps
    -- その他のキーマップ
    nmap('<Leader>fc', builtin.commands, { desc = '[F]ind [C]ommands' }) -- コマンドを検索
    nmap('<Leader>s', builtin.lsp_document_symbols, { desc = 'Search Document [S]ymbols' }) -- ドキュメントシンボルを検索
    nmap('<Leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' }) -- 診断情報を検索
  end,

  -- This function is executed to configure the plugin.
  -- この関数はプラグインの設定を行うために実行されます。
  config = function()
    -- Telescopeとactionsモジュールを取得
    local telescope = require("telescope")
    local actions = require('telescope.actions')

    -- Telescopeのセットアップ
    telescope.setup({
      -- Default options for all pickers
      -- 全てのピッカーに適用されるデフォルトオプション
      defaults = {
        -- Your default settings go here
        -- ここにデフォルト設定を追加できます
      },
      -- Options for specific pickers
      -- 特定のピッカーに対するオプション
      pickers = {
        live_grep = {
          mappings = {
            i = {
              -- Send results to quickfix list on Ctrl-o
              -- 検索結果をCtrl-oでquickfixリストに送る
              ['<C-o>'] = actions.send_to_qflist + actions.open_qflist,
              -- Send results to location list on Ctrl-l
              -- 検索結果をCtrl-lでロケーションリストに送る
              ['<C-l>'] = actions.send_to_loclist + actions.open_loclist,
            }
          }
        }
      },
      -- Load extensions
      -- 拡張機能のロード
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({})
        }
      }
    })

    -- Load extensions that need to be loaded explicitly
    -- 明示的にロードする必要がある拡張機能
    telescope.load_extension("ui-select")
    telescope.load_extension("egrepify")
  end,
}