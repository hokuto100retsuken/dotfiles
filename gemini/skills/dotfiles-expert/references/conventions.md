# 規約と仕様

このリポジトリの詳細な技術情報です。

## カラーパレット (Carbonfox 風)

以下の 16 進数コードは、Fish プロンプトやその他の UI 要素で使用されています：

| 要素 | カラー名 | 16 進数コード |
| :--- | :--- | :--- |
| プロジェクト名 | Blue | `#78a9ff` |
| Git 情報 | Yellow/Teal | `#08bdba` |
| Git ユーザー | Coral/Peach | `#ffc0b9` |
| Docker 情報 | Subtext | `#6e6f70` |
| パッケージ版 | Mauve | `#be95ff` |
| Node.js | Green | `#25be6a` |
| Ruby | Pink/Red | `#ee5396` |
| 実行時間 | Lavender | `#c8a5ff` |

## シンボリックリンクのガイドライン

`setup-dotfiles.sh` にシンボリックリンクを追加する場合：

1.  ソースディレクトリには `$DOTPATH` を使用。
2.  ターゲットには `$HOME` またはフルパスを使用。
3.  親ディレクトリの存在を確認するか、自動で処理する `create_symlink` を使用。

例：
```bash
create_symlink "$DOTPATH/config/mytool/config" "$HOME/.config/mytool/config"
```

## Neovim 設定

- 設定場所: `config/nvim/`
- カスタムロジック: `lua/my/`
- ユーザーモジュール:
    - `core/`: 基本設定、キーマップ、自動コマンド。
    - `plugins/`: プラグイン固有の設定。
- プラグインは `lua/my/plugins/` 内に個別のファイルとして定義。

## Fish Shell 設定

- `config.fish`: メインエントリポイント。
- `conf.d/`: OS 固有または機能固有のスニペット。
- `functions/`: 再利用可能な Fish 関数。
