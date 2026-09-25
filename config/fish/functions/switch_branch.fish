function switch_branch
    commandline -f repaint

    set -l branches (git branch --format="%(refname:short)")
    if test (count $branches) -gt 0
        set -l branch (printf '%s\n' $branches | fzf --height 40% --layout=reverse --preview-window=right:60% --preview="git log --oneline --graph --decorate --all -10 {}")
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
