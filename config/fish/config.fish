#view
set -g theme_display_date yes
set -g theme_date_format "+%F %H:%M"
set -g theme_display_git_default_branch yes
set -g theme_color_scheme dark

#path
set -x PATH $HOME/.nodebrew/current/bin $PATH

set -x PYENV_ROOT $HOME/.pyenv
set -x PATH  $PYENV_ROOT/bin $PATH
pyenv init - | source

#peco setting
set fish_plugins theme peco

function fish_user_key_bindings
  bind \cw peco_select_history
end
