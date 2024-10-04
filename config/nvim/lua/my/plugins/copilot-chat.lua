-- ローカルスコープに ShowCopilotChatActionPrompt 関数を移動
local function ShowCopilotChatActionPrompt()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
  
  -- キーマッピングを関数内に移動
  vim.api.nvim_set_keymap("n", "<leader>ccp", "<cmd>lua ShowCopilotChatActionPrompt()<cr>",
    { noremap = true, silent = true })
end

-- プラグインの設定を別のテーブルに移動
local plugin_config = {
  debug = true,   -- Enable debugging
  prompts = {
    Explain = {
      prompt = '/COPILOT_EXPLAIN カーソル上のコードの説明を段落をつけて表示してください。', 
    },
    Tests = {
      prompt = '/COPILOT_TESTS テストを書いてください。',
    },
    Fix = {
      prompt = '/COPILOT_FIX このコードには問題があります。バグを修正してください。',
    },
    Optimize = {
      prompt = '/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。',
    },
    Implement = {
      prompt = '/COPILOT_IMPLEMENT この関数を実装してください。',
    },
  }  -- See Configuration section for rest
}

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },   -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },    -- for curl, log wrapper
    },
    opts = plugin_config,
    -- See Commands section for default commands if you want to lazy load on them
  },
}

