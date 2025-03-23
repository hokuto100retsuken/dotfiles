#view
set -g theme_display_date yes
set -g theme_date_format "+%F %H:%M"
set -g theme_display_git_default_branch yes
set -g theme_color_scheme dark

#  functions
function pbr
    # Git ブランチの一覧を取得（現在のブランチには * が付いているので除去）
    set branches (git branch --format="%(refname:short)")
    if test (count $branches) -gt 0
        # peco で選択
        set branch (string join \n $branches | peco)
        if test -n "$branch"
            set -l output (git checkout $branch 2>&1)
            set -l exit_status $status
            echo $output
            if test $exit_status -ne 0
                echo "ブランチの切り替えに失敗しました。"
            end
            commandline -f repaint
        end
    else
        echo "No branches found."
        commandline -f repaint
    end
end

#  key bind
bind \cb 'pbr'
