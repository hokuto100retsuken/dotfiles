#view
set -g theme_display_date yes
set -g theme_date_format "+%F %H:%M"
set -g theme_display_git_default_branch yes
set -g theme_color_scheme dark

# ghq select option
set -g GHQ_SELECTOR fzf
set -g GHQ_SELECTOR_OPTS --reverse --height=40% --ansi --color bg+:13,hl:3,pointer:7

# functions
function switch_branch
    # 入力欄の再描画（fzf開始前に実行）
    commandline -f repaint

    # Git ブランチの一覧を取得（現在のブランチには * が付いているので除去）
    set branches (git branch --format="%(refname:short)")
    if test (count $branches) -gt 0
        # fzf で選択（画面全体を消さず、入力下に表示）
        set branch (string join \n $branches | fzf --height 20% --border --ansi)
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

    # 入力欄の再描画（fzf終了後に実行）
    commandline -f repaint
end

# key bind
bind \cb 'switch_branch'

set env_file "$HOME/.config/fish/envvars.txt"

if test -f $env_file
    while read -l key value
        # 空行やコメント行をスキップ
        if test -n "$key"; and not string match -q "#*" $key
            set -gx $key $value
        end
    end < $env_file
end
