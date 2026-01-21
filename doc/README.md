# My Neovim Configuration

This is my personal Neovim configuration, optimized for modern and efficient development.
これは、モダンで効率的な開発のために最適化された、私の個人的なNeovim設定です。

## Overview

This configuration aims to provide a fast, beautiful, and highly functional development environment. It uses `lazy.nvim` for plugin management and offers a wide range of features including LSP, auto-completion, Git integration, and an improved user interface.

この設定は、高速で美しく、高機能な開発環境を提供することを目指しています。プラグイン管理には `lazy.nvim` を使用し、LSP、自動補完、Git連携、UI改善など、幅広い機能を提供します。

## Prerequisites

*   Neovim (v0.8.0 or later recommended)
*   `git`
*   A [Nerd Font](https://www.nerdfonts.com/) (for icons)
*   [ripgrep](https://github.com/BurntSushi/ripgrep) (for `live_grep`)
*   [lazygit](https://github.com/jesseduffield/lazygit) (optional, for Git UI)

## Installation

1.  Clone this `dotfiles` repository.
2.  Run the setup script from the root of the repository.

```bash
cd /path/to/dotfiles
./setup-dotfiles.sh
```
This script will create symbolic links for the necessary configuration files, including Neovim's, in your home directory.
Upon first launch, `lazy.nvim` will automatically install all the plugins.

## Plugin Management

Plugins are managed using [lazy.nvim](https://github.com/folke/lazy.nvim). The configuration is designed to be easily maintainable.
プラグインは[lazy.nvim](https://github.com/folke/lazy.nvim)を使用して管理されます。メンテナンスが容易になるように設計されています。

*   **Plugin Specs**: Each plugin is configured in its own file under `lua/my/plugins/`.
*   **各プラグイン設定**: 各プラグインは `lua/my/plugins/` ディレクトリ内の個別のファイルで設定されます。

### Adding a Plugin

Simply create a new Lua file in the `lua/my/plugins/` directory. `lazy.nvim` will automatically detect and load it.
`lua/my/plugins/` ディレクトリに新しいLuaファイルを作成するだけです。`lazy.nvim` が自動的にそれを検出して読み込みます。

Example `lua/my/plugins/new-plugin.lua`:
```lua
return {
  "author/new-plugin.nvim",
  -- Optional: add configuration below
  opts = {},
}
```

### Disabling a Plugin

To disable a plugin, you can either delete its file or add `enabled = false` to its specification.
プラグインを無効にするには、そのファイルを削除するか、仕様に `enabled = false` を追加します。

```lua
return {
  "author/some-plugin.nvim",
  enabled = false,
}
```

## Keymaps

The leader key is `Space`.
リーダーキーは `Space` です。

### General / 一般

| Key | Description |
| :--- | :--- |
| `<F1>` | Open the main configuration file (`init.lua`) / 設定ファイルを開く |
| `<leader>h` | Clear search highlights / 検索ハイライトをクリア |
| `<leader>ww` | Save file / ファイルを保存 |
| `<leader>qq` | Quit / 終了 |

### Window Management / ウィンドウ管理

| Key | Description |
| :--- | :--- |
| `ss` | Split window horizontally / 画面を水平に分割 |
| `sv` | Split window vertically / 画面を垂直に分割 |
| `<leader>wh` | Move to left window / 左のウィンドウに移動 |
| `<leader>wj` | Move to lower window / 下のウィンドウに移動 |
| `<leader>wk` | Move to upper window / 上のウィンドウに移動 |
| `<leader>wl` | Move to right window / 右のウィンドウに移動 |
| `<leader>wq` | Close window / ウィンドウを閉じる |

### Telescope (Fuzzy Finder) / Telescope（ファジーファインダー）

| Key | Description |
| :--- | :--- |
| `<leader>ff` | Find files / ファイルを検索 |
| `<leader>fg` | Grep in project / プロジェクト内をGrep検索 |
| `<leader>fb` | Find buffers / バッファを検索 |
| `<leader>fh` | Find help tags / ヘルプタグを検索 |
| `<leader>fo` | Find old files / 最近開いたファイルを検索 |
| `<leader>fs` | Show Git status / Gitのステータスを表示 |
| `<leader>fc` | Find commands / コマンドを検索 |
| `<leader>fd` | Show LSP diagnostics / LSPの診断情報を一覧表示 |
| `<leader>s` | Search document symbols / ドキュメントシンボルを検索 |

### LSP / 言語サーバープロトコル

| Key | Description |
| :--- | :--- |
| `gD` | Go to declaration / 宣言へ移動 |
| `gd` | Go to definition / 定義へ移動 |
| `K` | Show hover information / ホバー情報を表示 |
| `gi` | Go to implementation / 実装へ移動 |
| `<C-k>` | Show signature help / シグネチャヘルプを表示 |
| `<leader>rn` | Rename symbol / シンボルをリネーム |
| `<leader>ca` | Code action / コードアクション |
| `gr` | Show references / 参照を表示 |
| `<leader>f` | Format code / コードをフォーマット |
| `[d` | Go to previous diagnostic / 前の診断へ移動 |
| `]d` | Go to next diagnostic / 次の診断へ移動 |
| `<leader>q` | Show diagnostics in location list / ロケーションリストに診断を表示 |

### Git / Git

| Key | Description |
| :--- | :--- |
| `<leader>gg` | Toggle `lazygit` terminal UI / `lazygit`のUIを開閉 |

### File Explorer (nvim-tree) / ファイルエクスプローラー

| Key | Description |
| :--- | :--- |
| `<leader>ee` | Toggle file explorer / ファイルエクスプローラーの表示/非表示を切り替え |
| `<leader>ef` | Toggle file explorer on current file / 現在のファイルの場所でファイルエクスプローラーを開く/閉じる |
| `<leader>ec` | Collapse file explorer / ファイルエクスプローラーを折りたたむ |
| `<leader>er` | Refresh file explorer / ファイルエクスプローラーを更新 |

### Harpoon / Harpoon

| Key | Description |
| :--- | :--- |
| `<leader>hm` | Mark file with harpoon / ファイルをハープーンでマーク |
| `<leader>hn` | Go to next harpoon mark / 次のハープーンマークへ移動 |
| `<leader>hp` | Go to previous harpoon mark / 前のハープーンマークへ移動 |

### Session Management / セッション管理

| Key | Description |
| :--- | :--- |
| `<leader>wr` | Restore session for current directory / 現在のディレクトリのセッションを復元 |
| `<leader>ws` | Save session for current directory / 現在のディレクトリのセッションを保存 |

### Notifications / 通知

| Key | Description |
| :--- | :--- |
| `<leader>nh` | Show notification history / 通知履歴を表示 |
| `<leader>nc` | Dismiss all notifications / すべての通知を閉じる |

### Flash Navigation / Flashナビゲーション

| Key | Description |
| :--- | :--- |
| `s` | Flash jump (forward) / Flashジャンプ（前方） |
| `S` | Flash treesitter search / Flash treesitter検索 |
| `r` (in visual/operator mode) | Flash remote / Flashリモート |

## Included Plugins

Below is a list of the main plugins, categorized by function.
以下は、主要なプラグインを機能別に分類したリストです。

### UI

*   [alpha-nvim](https://github.com/goolord/alpha-nvim): A beautiful dashboard.
*   [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim): Statusline.
*   [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim): Colorscheme.
*   [nvim-notify](https://github.com/rcarriga/nvim-notify): Notification manager.
*   [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua): File explorer.
*   [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons): Icons for files and UI.
*   [which-key.nvim](https://github.com/folke/which-key.nvim): Displays keybinding hints.

### Coding Assistance

*   [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter): Advanced syntax highlighting and parsing.
*   (LSP, completion, and linting plugins are configured in `linting.lua` and other files)

### Git Integration

*   [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim): Git decorations in the sign column.
*   [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) with `lazygit`.

### Utility

*   [auto-session](https://github.com/rmagatti/auto-session): Session manager.
*   [harpoon](https://github.com/ThePrimeagen/harpoon): File and command quick access.
*   [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim): Highly extendable fuzzy finder.
*   [helpful.nvim](https://github.com/loctvl842/helpful.nvim): Better help viewer.

For more details, please refer to the configuration files in the `lua/my/plugins/` directory.
詳細については `lua/my/plugins/` ディレクトリ内の設定ファイルを参照してください。