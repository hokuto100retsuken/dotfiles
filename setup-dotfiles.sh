#!/bin/bash

set -euo pipefail

DOTPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# バックアップ関数
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
        echo "既存の設定ファイルをバックアップ: $target -> $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    fi
}

# シンボリックリンク作成関数
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ ! -e "$source" ]]; then
        echo "警告: ソースファイルが存在しません: $source"
        return 1
    fi
    
    backup_if_exists "$target"
    
    local target_dir=$(dirname "$target")
    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
        echo "ディレクトリを作成: $target_dir"
    fi
    
    ln -sfv "$source" "$target"
}

echo "dotfilesのセットアップを開始します..."
echo "バックアップディレクトリ: $BACKUP_DIR"

# git config
create_symlink "$DOTPATH/git/_gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTPATH/git/_gitconfig-github" "$HOME/src/github.com/.gitconfig"

# fish
create_symlink "$DOTPATH/config/fish/config.fish" "$HOME/.config/fish/config.fish"
create_symlink "$DOTPATH/config/fish/conf.d" "$HOME/.config/fish/conf.d"
create_symlink "$DOTPATH/config/fish/functions" "$HOME/.config/fish/functions"

# ghostty
create_symlink "$DOTPATH/config/ghostty/config" "$HOME/.config/ghostty/config"

# nvim
create_symlink "$DOTPATH/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
create_symlink "$DOTPATH/config/nvim/lua" "$HOME/.config/nvim/lua"
create_symlink "$DOTPATH/config/nvim/sonictemplate" "$HOME/.config/nvim/sonictemplate"

# zellij
create_symlink "$DOTPATH/config/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
create_symlink "$DOTPATH/config/zellij/layouts" "$HOME/.config/zellij/layouts"

# mise
create_symlink "$DOTPATH/config/mise/config.toml" "$HOME/.config/mise/config.toml"

# claude
# CLAUDE.md / rulesはディレクトリ（またはファイル）単位でsymlink
create_symlink "$DOTPATH/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
create_symlink "$DOTPATH/claude/rules" "$HOME/.claude/rules"

# skills / commandsはprivate repo (dotfiles-pepabo等) からも個別追加する構成なので、
# ディレクトリ自体ではなく配下のitemを個別symlinkする
mkdir -p "$HOME/.claude/skills" "$HOME/.claude/commands"
for skill in "$DOTPATH"/claude/skills/*/; do
    [[ -d "$skill" ]] || continue
    create_symlink "${skill%/}" "$HOME/.claude/skills/$(basename "$skill")"
done
for cmd in "$DOTPATH"/claude/commands/*.md; do
    [[ -f "$cmd" ]] || continue
    create_symlink "$cmd" "$HOME/.claude/commands/$(basename "$cmd")"
done

# gemini
create_symlink "$DOTPATH/gemini/GEMINI.md" "$HOME/.gemini/GEMINI.md"
create_symlink "$DOTPATH/gemini/skills" "$HOME/.gemini/skills"

echo ""
echo "✓ dotfilesのセットアップが完了しました"
if [[ -d "$BACKUP_DIR" ]]; then
    echo "バックアップは $BACKUP_DIR に保存されました"
fi