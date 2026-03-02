#view
set -g theme_display_date yes
set -g theme_date_format "+%F %H:%M"
set -g theme_display_git_default_branch yes
set -g theme_color_scheme dark

# pure-fish settings to match the provided Starship example
set -g pure_enable_single_line_prompt no
set -g pure_symbol_prompt "❯"
set -g pure_symbol_git_untracked " ?"
set -g pure_symbol_git_dirty " *"
set -g pure_symbol_git_pull " ⇣"
set -g pure_symbol_git_push " ⇡"

# Use Powerline symbols for Git
set -g pure_symbol_git_branch " "

# Colors (Carbonfox-like)
set -g pure_color_primary blue
set -g pure_color_info cyan
set -g pure_color_mute brblack
set -g pure_color_success green
set -g pure_color_danger red
set -g pure_color_warning yellow
set -g pure_color_git_branch yellow
set -g pure_color_git_dirty yellow

# Custom function to show extra info (via Node, via Ruby, etc.)
# This will be prepended to the pure prompt
function _pure_prompt_extra_info
    set -l info ""
    
    # Docker/Colima check
    if command -v colima >/dev/null; and colima status >/dev/null 2>&1
        set info "$info via 🐳 colima"
    end
    
    # Node.js
    if command -v node >/dev/null
        set -l node_v (node -v)
        set info "$info via  $node_v"
    end
    
    # Ruby
    if command -v ruby >/dev/null
        set -l ruby_v (ruby -v | awk '{print $2}')
        set info "$info via 💎 v$ruby_v"
    end
    
    echo -n -s (set_color brblack) $info (set_color normal)
end

# Pure allows prepending to its prompt
# Note: pure might not have a direct 'prepend' variable for the top line,
# so we might need to override the fish_prompt slightly or use its hooks.
# For now, let's set the basic variables.

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
fish_add_path $HOME/.local/bin
