local wezterm = require 'wezterm';

local function BaseName(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on('format-windowtitle', function(tab)
    return BaseName(tab.activate_pane.foreground_process_name)
end)

local HEADER = ''
local SYMBOL_COLOR = { '#ffb2cc', '#a4a4a4' }
local FONT_COLOR = { '#dddddd', '#888888' }
local BACK_COLOR = '#2a2a2a'
local HOVER_COLOR = '#3a3a3a'

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local index = tab.is_active and 1 or 2

  local bg = hover and HOVER_COLOR or BACK_COLOR
  local zoomed = tab.active_pane.is_zoomed and '🔎 ' or ' '

  return {
    { Foreground = { Color = SYMBOL_COLOR[index] } },
    { Background = { Color = bg } },
    { Text = HEADER .. zoomed },

    { Foreground = { Color = FONT_COLOR[index] } },
    { Background = { Color = bg } },
    { Text = tab.active_pane.title },
  }
end)

