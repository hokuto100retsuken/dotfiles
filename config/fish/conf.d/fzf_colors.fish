# fzf default options (Carbonfox 風。fish のプロンプトと同じ色)
# bg:-1 でターミナルの背景を使い、Ghostty の透過を活かす
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border=rounded --info=inline --cycle \
--color=bg+:#283b4d,bg:-1,spinner:#78a9ff,hl:#08bdba \
--color=fg:#cdcecf,header:#08bdba,info:#be95ff,pointer:#78a9ff \
--color=marker:#25be6a,fg+:#f2f4f8,prompt:#78a9ff,hl+:#08bdba,border:#8d8e8f"

# Use fd instead of find
set -gx FZF_DEFAULT_COMMAND "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

# jethrokuan/fzf 固有の設定
# このプラグインは環境変数 FZF_CTRL_R_OPTS ではなく、fish 変数を使います
set -g FZF_REVERSE_ISEARCH_OPTS "--height 40% --layout=reverse --border --info=inline --no-sort --exact"

# fzf-fish plugin configurations (念のため)
set -g fzf_preview_file_cmd bat --color=always --style=numbers
set -g fzf_preview_dir_cmd eza --all --color=always --icons --tree --level=2
