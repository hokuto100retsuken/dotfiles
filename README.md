# dotfiles

個人用の設定ファイル（dotfiles）を管理するリポジトリです。
`fish`, `mise`, `Neovim`, `ghostty` を中心とした、一貫性のある開発環境の構築を目指しています。

## 主な使用ツール

| カテゴリ | ツール | 役割 |
| :--- | :--- | :--- |
| **ターミナル** | [ghostty](https://github.com/ghostty/ghostty) | GPUアクセラレーション対応ターミナル |
| **シェル** | [fish](https://fishshell.com/) | 高機能シェル |
| **プラグイン管理** | [fisher](https://github.com/jorgebucaran/fisher) | fish のプラグインマネージャ |
| **エディタ** | [Neovim](https://neovim.io/) | Vimベースのエディタ |
| **Git UI** | [lazygit](https://github.com/jesseduffield/lazygit) | ターミナルGit UI |
| **ツール管理** | [mise](https://mise.jdx.dev/) | CLIツール・ランタイムのバージョン管理 |

クロスプラットフォーム (Linux / macOS) 対応。

## ディレクトリ構成

```
.
├── config/
│   ├── fish/       # fish shell
│   ├── ghostty/    # ghostty
│   ├── mise/       # mise
│   ├── nvim/       # Neovim
│   └── zellij/     # zellij
├── git/            # Git設定
├── claude/         # Claude Code スキル・コマンド
├── gemini/         # Gemini CLI スキル
├── doc/            # ドキュメント
├── setup.sh        # セットアップ（メインスクリプト）
├── setup-installs.sh
├── setup-dotfiles.sh
└── setup-fish.sh
```

## インストール

```bash
git clone https://github.com/hokuto100retsuken/dotfiles.git
cd dotfiles
bash setup.sh --all
```

`setup.sh` のオプション:

| オプション | 内容 |
| :--- | :--- |
| `--all` | すべて実行 |
| `--install` | パッケージインストールのみ |
| `--dotfiles` | シンボリックリンク作成のみ |
| `--fish` | fish プラグインインストールのみ |
| `--interactive` | 対話モード |

引数なしで実行するとインタラクティブモードを提案します。

### macOS: デフォルトシェルをfishに変更

```bash
sudo sh -c 'echo $(which fish) >> /etc/shells'
chsh -s $(which fish)
```

## トラブルシューティング

- **シンボリックリンクの競合**: `setup-dotfiles.sh` が既存ファイルを `~/.dotfiles-backup-*` に自動バックアップ
- **パッケージインストール失敗**: 失敗したパッケージは表示されるので手動インストール
- **Neovimプラグイン**: 初回起動時に `lazy.nvim` が自動インストール
