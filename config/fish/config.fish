#view
set -g theme_display_date yes
set -g theme_date_format "+%F %H:%M"
set -g theme_display_git_default_branch yes
set -g theme_color_scheme dark

#path
set -x PATH $HOME/.nodebrew/current/bin $PATH

# peco setting
set fish_plugins theme peco

starship init fish | source

# alias docker-compose 'docker compose'
alias docker-compose="docker compose"

eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

