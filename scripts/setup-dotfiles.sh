#!/bin/bash

set -euo pipefail

# scripts/ 配下から見てリポジトリルートは1階層上
DOTPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# --- Helper Functions ---

# Backup function: Moves existing target to backup directory if it exists and is not a symlink.
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
        echo "  [BACKUP] Backing up existing configuration: $target -> $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    fi
}

# Symlink creation function: Creates a symbolic link from source to target.
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ ! -e "$source" ]]; then
        echo "  [WARN] Source file does not exist: $source"
        return 1
    fi
    
    backup_if_exists "$target"

    local target_dir=$(dirname "$target")
    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
        echo "  [DIR] Created directory: $target_dir"
    fi

    # Remove existing symlink at target before creating a new one
    [[ -L "$target" ]] && rm "$target"
    ln -sfv "$source" "$target"
    if [[ $? -eq 0 ]]; then
        echo "  [LINK] Successfully linked: $source -> $target"
    else
        echo "  [ERROR] Failed to create symlink for $target." >&2
        return 1
    fi
}

# --- Linking Sections ---

link_git() {
    echo -e "\n--- Linking Git Configurations ---"
    create_symlink "$DOTPATH/git/_gitconfig" "$HOME/.gitconfig"
    create_symlink "$DOTPATH/git/_gitconfig-github" "$HOME/src/github.com/.gitconfig"
    create_symlink "$DOTPATH/git/_gitignore_global" "$HOME/.gitignore_global"
}

link_shell() {
    echo -e "\n--- Linking Shell Configurations ---"
    # fish
    create_symlink "$DOTPATH/config/fish/config.fish" "$HOME/.config/fish/config.fish"
    create_symlink "$DOTPATH/config/fish/conf.d" "$HOME/.config/fish/conf.d"
    create_symlink "$DOTPATH/config/fish/functions" "$HOME/.config/fish/functions"
    create_symlink "$DOTPATH/config/fish/fish_plugins" "$HOME/.config/fish/fish_plugins"

    # ghostty
    create_symlink "$DOTPATH/config/ghostty/config" "$HOME/.config/ghostty/config"

    # nvim (Directory symlink)
    echo "  [DIR] Linking entire Neovim config directory..."
    create_symlink "$DOTPATH/config/nvim" "$HOME/.config/nvim"

    # herdr
    create_symlink "$DOTPATH/config/herdr/config.toml" "$HOME/.config/herdr/config.toml"

    # zellij
    echo "  [DIR] Linking Zellij configurations..."
    create_symlink "$DOTPATH/config/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
    create_symlink "$DOTPATH/config/zellij/layouts" "$HOME/.config/zellij/layouts"

    # mise
    create_symlink "$DOTPATH/config/mise/config.toml" "$HOME/.config/mise/config.toml"
}

# Handles the complex, nested linking for claude's rules/skills/commands/agents/workflows
link_claude() {
    echo -e "\n--- Linking Claude Configurations ---"
    create_symlink "$DOTPATH/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
    create_symlink "$DOTPATH/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

    # Ensure base directories exist
    mkdir -p "$HOME/.claude/rules" "$HOME/.claude/skills" "$HOME/.claude/commands" \
             "$HOME/.claude/agents" "$HOME/.claude/workflows"

    # Rules (Individual files)
    echo "  [FILES] Linking Claude rules..."
    for rule in "$DOTPATH"/claude/rules/*.md; do
        [[ -f "$rule" ]] || continue
        basename_file=$(basename "$rule")
        create_symlink "$rule" "$HOME/.claude/rules/$basename_file"
    done

    # Skills (Directories)
    echo "  [DIRS] Linking Claude skills..."
    for skill in "$DOTPATH"/claude/skills/*/; do
        [[ -d "$skill" ]] || continue
        basename_dir=$(basename "$skill")
        create_symlink "${skill%/}" "$HOME/.claude/skills/$basename_dir"
    done

    # Commands (Individual files)
    echo "  [FILES] Linking Claude commands..."
    for cmd in "$DOTPATH"/claude/commands/*.md; do
        [[ -f "$cmd" ]] || continue
        basename_file=$(basename "$cmd")
        create_symlink "$cmd" "$HOME/.claude/commands/$basename_file"
    done

    # Agents (Individual files)
    echo "  [FILES] Linking Claude agents..."
    for agent in "$DOTPATH"/claude/agents/*.md; do
        [[ -f "$agent" ]] || continue
        basename_file=$(basename "$agent")
        create_symlink "$agent" "$HOME/.claude/agents/$basename_file"
    done

    # Workflows (Individual files)
    echo "  [FILES] Linking Claude workflows..."
    for workflow in "$DOTPATH"/claude/workflows/*.js; do
        [[ -f "$workflow" ]] || continue
        basename_file=$(basename "$workflow")
        create_symlink "$workflow" "$HOME/.claude/workflows/$basename_file"
    done
}

# Handles the gemini linking
link_gemini() {
    echo -e "\n--- Linking Gemini Configurations ---"
    create_symlink "$DOTPATH/gemini/GEMINI.md" "$HOME/.gemini/GEMINI.md"
    create_symlink "$DOTPATH/gemini/skills" "$HOME/.gemini/skills"
}

# Main execution function
main() {
    echo "=========================================="
    echo "Starting dotfiles setup..."
    echo "Source directory: $DOTPATH"
    echo "Backup directory: $BACKUP_DIR"
    echo "=========================================="

    link_git
    link_shell
    link_claude
    link_gemini

    echo ""
    echo "✅ Dotfiles setup completed successfully."
    if [[ -d "$BACKUP_DIR" ]]; then
        echo "⚠️ Backup files were saved to $BACKUP_DIR"
    fi
}

main
