# dotfiles

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

## 注意事項

- アスキーアートやUI要素の変更は、大幅に書き換えず小さな差分で提案すること
- 曖昧な見た目の指示（「モダンにして」等）は、方向性を先に確認してから作業する
- symlink先は `~/.config/` 配下。変更はこのリポジトリ側で行う
