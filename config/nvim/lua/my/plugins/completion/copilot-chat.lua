-- telescope を使ってアクションプロンプトを表示する
function ShowCopilotChatActionPrompt()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end

-- キーマッピング
-- <leader>ccp (Copilot Chat Prompt の略) でアクションプロンプトを表示する
vim.api.nvim_set_keymap("n", "<leader>ccp", "<cmd>lua ShowCopilotChatActionPrompt()<cr>",
  { noremap = true, silent = true })

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },   -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },    -- for curl, log wrapper
    },
    opts = {
      debug = true,   -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
