#view
set -g theme_display_date yes
set -g theme_date_format "+%F %H:%M"
set -g theme_display_git_default_branch yes
set -g theme_color_scheme dark

# ghq select option
set -g GHQ_SELECTOR fzf

# fzf settings
set -g FZF_DEFAULT_OPTS "--height 40% --layout=reverse-list --border --info=inline --cycle"
set -g FZF_DEFAULT_COMMAND "fd --type f"

# functions
function switch_branch
    # 入力欄の再描画（fzf開始前に実行）
    commandline -f repaint

    # Git ブランチの一覧を取得（現在のブランチには * が付いているので除去）
    set branches (git branch --format="%(refname:short)")
    if test (count $branches) -gt 0
        # fzf で選択（画面全体を消さず、入力下に表示）
        set branch (printf '%s\n' $branches | fzf --preview-window=right:60% --preview="git log --oneline --graph --decorate --all -10 {}")
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

# ghq select and cd
function ghq_select
    set selected_dir (ghq list -p | fzf --height 40% --layout=reverse)
    if test -n "$selected_dir"
        cd "$selected_dir"
    end
    commandline -f repaint
end

bind \cg 'ghq_select'

set env_file "$HOME/.config/fish/envvars.txt"

# スペース区切りの環境変数ファイルを読み込む
if test -f $env_file
    while read -l key value
        # 空行やコメント行をスキップ
        if test -n "$key"; and not string match -q "#*" $key
            set -gx $key $value
        end
    end < $env_file
end

# Load OS-specific config
set os_specific_conf "$HOME/.config/fish/conf.d/(uname).fish"
if test -f "$os_specific_conf"
    source "$os_specific_conf"
end
