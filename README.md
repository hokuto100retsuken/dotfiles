# dotfiles

![Lint](https://github.com/hokuto100retsuken/dotfiles/actions/workflows/lint.yml/badge.svg)

Carbonfox テーマを基調とした、一貫性のあるモダンな開発環境を構築するための設定群です。

## 🎨 コンセプト

- **Carbonfox Colors**: ターミナル、エディタ、プロンプトをすべて [Carbonfox](https://github.com/EdenEast/nightfox.nvim) カラーで統一。
- **Modern CLI Tools**: fish, Neovim, ghostty, mise, zellij などの高速で高機能なツールを活用。
- **Automated Setup**: スクリプト一発で、シンボリックリンク作成からプラグインのインストールまで完了。

## 🛠 主な使用ツール

| カテゴリ | ツール | 役割 |
| :--- | :--- | :--- |
| **ターミナル** | [ghostty](https://github.com/ghostty/ghostty) | GPUアクセラレーション対応ターミナル |
| **シェル** | [fish](https://fishshell.com/) | 高機能シェル + fzf プレビュー強化 |
| **エディタ** | [Neovim](https://neovim.io/) | LSP/フォーマッタ完備のエディタ |
| **Git UI** | [lazygit](https://github.com/jesseduffield/lazygit) | ターミナルGit UI |
| **ツール管理** | [mise](https://mise.jdx.dev/) | CLIツール・ランタイムのバージョン管理 |

## 🚀 インストール

\`\`\`bash
git clone https://github.com/hokuto100retsuken/dotfiles.git
cd dotfiles
bash setup.sh --all
\`\`\`

## 📂 ディレクトリ構成

- \`config/\`: 各ツールの設定ファイル（fish, nvim, ghostty 等）
- \`git/\`: Git のグローバル設定
- \`gemini/\`: Gemini CLI 用のスキル・規約
- \`claude/\`: Claude Code 用のルール・スキル
- `.github/`: 自動検証（Lint）用ワークフロー

## ⌨️ 主要なキーバインド (Ghostty / Fish)

- \`Cmd + Shift + T\`: クイックターミナルのトグル (Ghostty)
- \`Ctrl + G\`: リポジトリ選択 (ghq + fzf)
- \`Ctrl + B\`: Git ブランチ切り替え (fzf)
- \`Super + D\`: 画面右分割 (Ghostty)
- \`Super + Shift + D\`: 画面下分割 (Ghostty)

---
Developed by @hokuto100retsuken
