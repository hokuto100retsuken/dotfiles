#view
set -g theme_display_date yes
set -g theme_date_format "+%F %H:%M"
set -g theme_display_git_default_branch yes
set -g theme_color_scheme dark

#path
set -x PATH $HOME/.nodebrew/current/bin $PATH

# set -x PYENV_ROOT $HOME/.pyenv
# set -x PATH  $PYENV_ROOT/bin $PATH
# pyenv init - | source

#peco setting
set fish_plugins theme peco

function fish_user_key_bindings
  bind \cw peco_select_history
end

starship init fish | source

# source ~/.asdf/asdf.fish

# alias docker-compose 'docker compose'
alias docker-compose="docker compose"

eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

function list_git_branches
    if test -d .git
        set branch (git branch -a | fzf | sed 's/^[* ] //')
        git checkout $branch
    else
        echo "This is not a Git repository."
    end
end

bind \cb 'list_git_branches'

