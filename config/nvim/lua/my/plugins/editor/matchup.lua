-- This file configures vim-matchup, which highlights and navigates matching keyword pairs
-- such as def/end, if/end, do/end in Ruby, extending the built-in % motion.
-- このファイルは、Rubyの def/end・if/end・do/end などの対応キーワードを
-- ハイライト・ジャンプできるようにする vim-matchup を設定します（組み込みの % を拡張）。

local matchup = {
  "andymass/vim-matchup",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    -- Show the matching keyword in a popup when it is off-screen.
    -- 対応キーワードが画面外にある場合はポップアップで表示します。
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    -- Defer highlighting slightly to keep cursor movement responsive.
    -- カーソル移動の反応を保つため、ハイライトを少し遅延させます。
    vim.g.matchup_matchparen_deferred = 1
  end,
}

return matchup
