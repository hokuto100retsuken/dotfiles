# dotfiles

個人用の設定ファイル（dotfiles）を管理するリポジトリです。
`fish`, `mise`, `Neovim`, `ghostty` を中心とした、一貫性のある開発環境の構築を目指しています。

## ✨ 主な使用ツール (Main Tools)

この開発環境を構成する主要なツールです。各ツールの設定は `config/` ディレクトリにまとめています。

| カテゴリ | ツール | 役割 |
| :--- | :--- | :--- |
| **ターミナル** | [ghostty](https://github.com/ghostty/ghostty) | 高速でGPUアクセラレーションが効いたターミナルエミュレータ |
| **シェル** | [fish](https://fishshell.com/) | 使いやすく高機能なシェル |
| ├ **プロンプト** | [starship](https://starship.rs/) | 高速でカスタマイズ可能なプロンプト |
| └ **ﾌﾟﾗｸﾞｲﾝ管理** | [sheldon](https://github.com/rossmacarthur/sheldon) | `fish` のプラグインマネージャ |
| **エディタ** | [Neovim](https://neovim.io/) | 高速で拡張性の高いVimベースのエディタ |
| **ツール管理** | [mise](https.mise.jdx.dev/) | CLIツールとランタイムのバージョン管理 |
| **Git** | [gina.vim](https://github.com/lambdalisue/gina.vim) | Neovim上でのGit操作を非同期で行うプラグイン |

クロスプラットフォーム (Linux / macOS) での一貫した操作性を目指しています。

## 📂 ディレクトリ構成

```
.
├── config/         # 各種ツールの設定ファイル
│   ├── fish/       # fish shell
│   ├── mise/       # mise (CLI/Runtime version manager)
│   ├── nvim/       # Neovim
│   ├── sheldon/    # sheldon (fish plugin manager)
│   ├── starship.toml # starship prompt
│   └── ghostty/    # ghostty
├── git/            # Git関連の設定
├── setup-all.sh    # すべてをセットアップするスクリプト
└── ...
```

## 🛠️ 前提条件 (Prerequisites)

セットアップを実行する前に、以下のツールがインストールされている必要があります。

- `git`: リポジトリのクローンに使用します。
- `curl` または `wget`: インストールスクリプトのダウンロードに使用します。
- 各OSのパッケージマネージャ:
  - **Ubuntu**: `apt`
  - **Arch Linux**: `yay` (AURヘルパー)
  - **macOS**: `Homebrew`

## 🚀 インストール方法 (Installation)

1.  **リポジトリをクローン**

    まず、このリポジトリを任意の場所にクローンします。

    ```bash
    git clone https://github.com/hokuto100retsuken/dotfiles.git
    ```

2.  **セットアップスクリプトを実行**

    クローンしたディレクトリに移動し、セットアップスクリプトを実行します。
    このスクリプトは、OSを判別し、必要なパッケージのインストールと設定ファイルのシンボリックリンク作成をまとめて行います。

    ```bash
    cd dotfiles
    bash setup-all.sh
    ```

3.  **シェルを再起動**

    インストール完了後、ターミナルを再起動するか、新しいタブを開いてください。
    `fish`シェルが起動し、`mise`で管理されているツールが利用可能な状態になります。

    **macOSに関する注意:**
    デフォルトシェルを`fish`に変更するには、追加の操作が必要な場合があります。スクリプト内で自動変更されない場合は、手動で設定してください。

    ```bash
    # fishのパスを確認
    which fish

    # /etc/shells に fish のパスを追記
    sudo sh -c 'echo $(which fish) >> /etc/shells'

    # デフォルトシェルを変更
    chsh -s $(which fish)
    ```

## 使い方 (Usage)

### mise: ツールとランタイムの管理

CLIツールやプログラミング言語のランタイムは `mise` で管理します。
グローバル設定は `~/.config/mise/config.toml` で定義されています。

- **ツール/ランタイムをインストールする場合:**
  `mise install <tool_name>@<version>` または `.tool-versions` ファイルがあるディレクトリで `mise install` を実行します。

- **プロジェクトごとにバージョンを固定する場合:**
  プロジェクトのルートに `.tool-versions` ファイルを配置し、使用したいツールとバージョンを記述します。（例: `nodejs 20.11.0`）
