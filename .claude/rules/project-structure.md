---
description: dotfilesリポジトリの構造とNeovimプラグイン構成
globs:
---

個人の開発環境設定を管理するリポジトリ。

## 構造

```
config/
  fish/       # Fish shell設定・プラグイン(fisher)
  ghostty/    # Ghosttyターミナル設定
  mise/       # mise (asdf後継) のツールバージョン管理
  nvim/       # Neovim設定 (lazy.nvim)
  zellij/     # Zellijターミナルマルチプレクサ設定
git/          # gitconfig
setup.sh      # セットアップスクリプト (--all, --dotfiles, --fish, --install)
```

## Neovim プラグイン構成

`config/nvim/lua/my/plugins/` 以下にカテゴリ分け:
- `editor/` — エディタ操作系
- `git/` — Git連携
- `lsp/` — LSP設定
- `ui/` — UI系 (alpha-nvim等)
- `utility/` — ユーティリティ
