# abbreviations (展開されるので履歴に正式コマンドが残る)
abbr -a g git
abbr -a ga "git add"
abbr -a gaa "git add -A"
abbr -a gc "git commit"
abbr -a gcm "git commit -m"
abbr -a gco "git checkout"
abbr -a gsw "git switch"
abbr -a gswc "git switch -c"
abbr -a gst "git status -sb"
abbr -a gd "git diff"
abbr -a gdc "git diff --cached"
abbr -a gp "git push"
abbr -a gpf "git push --force-with-lease"
abbr -a gl "git pull"
abbr -a glog "git log --oneline --graph -20"
abbr -a gloga "git log --oneline --graph --all -20"
abbr -a ll "eza -la --icons --git"
abbr -a lt "eza --tree --level=2 --icons"
abbr -a cat bat
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a zj zellij
abbr -a zjd "zellij --layout dev"

# fzf settings
set -g FZF_DEFAULT_OPTS "--height 40% --layout=reverse-list --border --info=inline --cycle"
set -g FZF_DEFAULT_COMMAND "fd --type f"

# functions
function switch_branch
    commandline -f repaint

    set branches (git branch --format="%(refname:short)")
    if test (count $branches) -gt 0
        set branch (printf '%s\n' $branches | fzf --height 40% --layout=reverse --preview-window=right:60% --preview="git log --oneline --graph --decorate --all -10 {}")
        if test -n "$branch"
            set -l output (git checkout $branch 2>&1)
            set -l exit_status $status
            echo $output
            if test $exit_status -ne 0
                echo "ブランチの切り替えに失敗しました。"
            end
        end
    else
        echo "No branches found."
    end

    commandline -f repaint
end

bind \cb 'switch_branch'

function ghq_select
    set selected_dir (ghq list -p | fzf --height 40% --layout=reverse)
    if test -n "$selected_dir"
        cd "$selected_dir"
    end
    commandline -f repaint
end

bind \cg 'ghq_select'

# 環境変数ファイルの読み込み
set env_file "$HOME/.config/fish/envvars.txt"
if test -f $env_file
    while read -l key value
        if test -n "$key"; and not string match -q "#*" $key
            set -gx $key $value
        end
    end < $env_file
end

fish_add_path $HOME/.local/bin

# direnv (プロジェクトごとの環境変数を .envrc で自動切替)
if command -v direnv >/dev/null
    direnv hook fish | source
end
