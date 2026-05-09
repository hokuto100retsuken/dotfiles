# --- Environment Variables ---
fish_add_path $HOME/.local/bin

# 環境変数ファイルの読み込み
set env_file "$HOME/.config/fish/envvars.txt"
if test -f $env_file
    while read -l key value
        if test -n "$key"; and not string match -q "#*" $key
            set -gx $key $value
        end
    end < $env_file
end

# --- Tools Setup ---
# direnv (プロジェクトごとの環境変数を .envrc で自動切替)
if command -v direnv >/dev/null
    direnv hook fish | source
end

# mise (Tool version manager)
if command -v mise >/dev/null
    mise activate fish | source
end

# zoxide (Better cd)
if command -v zoxide >/dev/null
    zoxide init fish | source
end

# --- Interactive Session ---
if status is-interactive
    # Bindings for custom functions
    bind \cb 'switch_branch'
    bind \cg 'ghq_select'
    
    # Pluginのバインドを確実に上書きするための設定
    bind \cr 'fzf_history'
end
