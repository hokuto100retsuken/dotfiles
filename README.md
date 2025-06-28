# dotfiles

個人用の設定ファイル（dotfiles）を管理するリポジトリです。
`fish`, `aqua`, `mise` を中心としたモダンな環境構築を目指しています。

## ✨ 特徴 (Features)

- **シェル**: `fish` をデフォルトシェルとして使用し、強力な補完機能やシンタックスハイライトを活用します。
- **CLIツール管理**: [aqua](https://aquaproj.github.io/) を使用して、CLIツールのバージョンを宣言的に管理します。
- **ランタイム管理**: [mise](https://mise.jdx.dev/) を使用して、Node.js, Python, Goなどのランタイムバージョンをプロジェクトごとに管理します。
- **クロスプラットフォーム**: Linux (Ubuntu, Arch Linux) と macOS に対応しています。

## 🛠️ 前提条件 (Prerequisites)

セットアップを実行する前に、以下のツールがインストールされている必要があります。

- `git`: リポジトリのクローンに使用します。
- `curl`: インストールスクリプトのダウンロードに使用します。
- 各OSのパッケージマネージャ:
  - **Ubuntu**: `apt`
  - **Arch Linux**: `yay` (AURヘルパー)
  - **macOS**: `Homebrew`

## 🚀 インストール方法 (Installation)

以下の手順でセットアップを行います。

1.  **リポジトリをクローン**

    まず、このリポジトリを任意の場所にクローンします。

    ```bash
    git clone https://github.com/hokuto100retsuken/dotfiles.git
    ```

2.  **セットアップスクリプトを実行**

    クローンしたディレクトリに移動し、セットアップスクリプトを実行します。
    このスクリプトを実行すると、OSを自動で判別し、必要なパッケージのインストールと設定ファイルのシンボリックリンク作成をまとめて行います。

    ```bash
    cd dotfiles
    bash setup-all.sh
    ```

3.  **シェルを再起動**

    インストール完了後、ターミナルを再起動するか、新しいタブを開いてください。
    `fish`シェルが起動し、`aqua`や`mise`で管理されているツールが利用可能な状態になります。

    **macOSに関する注意:**
    デフォルトシェルを`fish`に変更するには、追加の操作が必要な場合があります。スクリプト内で自動変更されない場合は、手動で設定してください。

    ```bash
    # fishのパスを確認
    which fish

    # /etc/shells に fish のパスを追記
    sudo sh -c 'echo /path/to/your/fish >> /etc/shells'

    # デフォルトシェルを変更
    chsh -s /path/to/your/fish
    ```

## 使い方 (Usage)

### aqua: CLIツールの管理

CLIツールは `config/aqua/aqua.yaml` で管理されています。

- **ツールを追加する場合:**
  1. `config/aqua/aqua.yaml` の `packages` リストに追加したいツールを記述します。
     (利用可能なパッケージは [aqua Registry](https://aquaproj.github.io/aqua-registry/registry.json) で確認できます)
  2. ターミナルで `aqua install` (もしくは `aqua i`) を実行します。

- **グローバルなツールをインストールする場合:**
  `aqua g <package_name>` コマンドを使用します。

### mise: ランタイムの管理

プログラミング言語のランタイムは `mise` で管理します。

- **利用したいランタイムを設定する場合:**
  プロジェクトのディレクトリに `.tool-versions` ファイルを作成し、使用したいランタイムとバージョンを記述します。
  （例: `nodejs 20.11.0`）
  もしくは、`~/.config/mise/config.toml` でグローバルなバージョンを設定することも可能です。

- **ランタイムをインストールする場合:**
  設定ファイルを記述した後、`mise install` (もしくは `mise i`) を実行します。