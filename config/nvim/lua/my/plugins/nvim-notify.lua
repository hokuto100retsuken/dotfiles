local notify = {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require("notify")
    
    -- 通知の設定
    notify.setup({
      -- 通知の位置（右下）
      position = "bottom_right",
      
      -- 通知の最大幅
      max_width = 50,
      
      -- 通知の最大高さ
      max_height = 10,
      
      -- 通知の表示時間（ミリ秒）
      timeout = 3000,
      
      -- 通知の背景色の透明度
      background_colour = "#000000",
      
      -- 通知の境界線スタイル
      border_style = "rounded",
      
      -- 通知のアイコン
      icons = {
        DEBUG = "🐛",
        ERROR = "❌",
        INFO = "ℹ️",
        TRACE = "🔍",
        WARN = "⚠️",
      },
      
      -- 通知のレベル別の色
      level = 2, -- デフォルトレベル（INFO）
      
      -- 通知のアニメーション
      stages = "fade_in_slide_out",
      
      -- 通知のオーバーレイ
      render = "default",
      
      -- 通知の最小幅
      minimum_width = 20,
      
      -- 通知の最大幅
      maximum_width = 80,
    })
    
    -- 標準のvim.notifyをnvim-notifyに置き換え
    vim.notify = notify
  end,
}

return notify 