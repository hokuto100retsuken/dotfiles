---
name: dotfiles-expert
description: >
  この dotfiles リポジトリの管理と拡張に特化した知識を提供します。
  シェル設定 (fish)、ターミナル設定 (ghostty)、エディタ設定 (nvim) の変更、
  または新しい設定のシンボリックリンク追加時に使用します。
autoApply: true
---

# Dotfiles Expert

このスキルは、この特定のリポジトリの構造と規約を理解するのに役立ちます。

## リポジトリ構造

- `config/`: 主要な設定ファイル。ツール別（fish, nvim, ghostty, zellij, mise）に整理。
- `setup.sh`: エントリポイント。`--all / --dotfiles / --fish / --install` のフラグで下記サブスクリプトを呼び分ける。
- `setup-dotfiles.sh`: シンボリックリンク作成用スクリプト。`create_symlink` 関数を使用。
- `setup-installs.sh`: OS別パッケージインストール。
- `setup-fish.sh`: fish プラグインのインストール。
- `claude/`, `gemini/`: AI ツール固有のスキル・コマンドディレクトリ。
- `git/`: gitconfig。

## 基本規約

- **シンボリックリンク**: すべての設定はリポジトリから `~/.config/` または `$HOME` へリンク。新しい設定を追加する際は `setup-dotfiles.sh` に `create_symlink` を追加すること。
- **ルール類**: グローバル / プロジェクトのルールは `.claude/rules/` 配下に分割配置（`CLAUDE.md` は `.claude/rules/` への移行済み notice のみ）。
- **Fish Shell**: abbreviation でコマンド短縮。OS固有設定は `conf.d/Darwin.fish` / `conf.d/Linux.fish` に分離。
- **カラー**: Carbonfox 配色を統一使用。
- **Neovim**: `config/nvim/lua/my/plugins/` 配下にカテゴリ別（ui, editor, git, lsp, utility）で管理。lazy.nvim でプラグイン管理。
- **ターミナルマルチプレクサ**: Zellij をメインで使用。

## Neovim プラグイン追加手順

1. `config/nvim/lua/my/plugins/<category>/` に `<plugin-name>.lua` を作成
2. lazy.nvim の spec 形式で return する
3. キーマップには必ず `desc` を付ける（which-key に表示される）

## 新しい設定の追加手順

1. `config/<tool>/` にディレクトリ・ファイルを作成
2. `setup-dotfiles.sh` に `create_symlink` の呼び出しを追加
3. 必要なパッケージがあれば `setup-installs.sh` の packages 配列に追加
