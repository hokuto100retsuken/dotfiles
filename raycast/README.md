# Raycast

Raycast の設定のうち、**ファイルとして持ち出せるもの**をこのリポジトリで管理する。

Raycast の設定は保存形式が 3 種類に分かれていて、リポジトリで管理できる範囲が異なる。

| 種類 | 保存先 | 管理方法 |
| --- | --- | --- |
| Snippets / Quicklinks | Raycast 内部DB | JSON をエクスポート/インポート（このリポジトリの `*.json`） |
| Script Commands | 任意のディレクトリ | Raycast にディレクトリを登録するだけ（このリポジトリの `scripts/`） |
| Hotkey / Alias / 各種設定 | Raycast 内部DB | ファイル化できないため、後述の手順で手動設定する |

社内固有（`git.pepabo.com` / Redash / colorme のリポジトリ名など）の設定は、公開リポジトリに置けないため
[dotfiles-pepabo](https://git.pepabo.com/hokuto100retsuken/dotfiles-pepabo) の `raycast/` に分けてある。

## 構成

```
raycast/
├── snippets.json     # 日付・git・docker compose・レビュー定型文
├── quicklinks.json   # Google / MDN / npm など汎用の検索リンク
└── scripts/
    ├── ghq-open-in-editor.sh    # ghq のリポジトリを VS Code で開く
    ├── ghq-open-in-terminal.sh  # ghq のリポジトリを Ghostty で開く
    └── ghq-open-pr.sh           # ghq のリポジトリの、現在ブランチの PR を開く
```

## セットアップ

### 1. Snippets を取り込む

Raycast で `Import Snippets` を実行し、`raycast/snippets.json` を選ぶ。

キーワードはすべて `;` 始まりにしてある。通常の文章入力中に誤爆させないため。

| キーワード | 展開内容 |
| --- | --- |
| `;da` / `;dj` / `;dt` | 日付 (`2026-08-12` / `2026年8月12日` / `2026-08-12 14:30`) |
| `;cc` / `;ccc` / `;ccr` | `claude` / `claude --continue` / `claude --resume` |
| `;gcm` / `;gsc` / `;gpf` / `;glg` | git のよく使うコマンド |
| `;dcu` / `;dce` / `;dcr` | docker compose のよく使うコマンド |
| `;rt` / `;rf` / `;lg` / `;kn` | レビュー依頼・修正報告・LGTM・指摘への返信 |
| `;mc` / `;md` / `;mq` | コードブロック・details・クリップボードの引用 |
| `;sh` | bash の shebang + `set -euo pipefail` |

`{cursor}` を含むものは、展開後にカーソルがその位置に入る。

### 2. Quicklinks を取り込む

Raycast で `Import Quicklinks` を実行し、`raycast/quicklinks.json` を選ぶ。

いずれも引数つきで、Raycast から `g <検索語>` のように直接検索できる。

### 3. Script Commands を登録する

Raycast の `Settings → Extensions → Script Commands → Add Directories` で、このリポジトリの
`raycast/scripts` を追加する。symlink は不要で、ディレクトリを直接指定すればよい。

スクリプトは Raycast から**ログインシェルを経由せずに**実行されるため、`ghq` や `gh` を使うものは
スクリプト冒頭で `/opt/homebrew/bin` を PATH に足している。新しく追加するときも同様にする。

引数は部分一致で `ghq list` を絞り込むので、`api` や `cart` のように短く打てばよい。

### 4. 手動で設定する（ファイル化できない分）

#### 初期設定

- Raycast の起動ホットキーを `⌘ + Space` にする（macOS 側の Spotlight のショートカットを先に外す）

#### Hotkey

| コマンド | Hotkey |
| --- | --- |
| Clipboard History | `⌘ + ⇧ + V` |
| Search Snippets | `⌘ + ⇧ + B` |
| Left Half | `⌃ + ⌥ + ←` |
| Right Half | `⌃ + ⌥ + →` |
| Top Half | `⌃ + ⌥ + ↑` |
| Bottom Half | `⌃ + ⌥ + ↓` |
| Maximize | `⌃ + ⌥ + ↩` |

#### Alias

Raycast の検索窓で打つ短縮名。コマンドの詳細画面から設定する。

| コマンド | Alias |
| --- | --- |
| File Search | `f` |
| Search Emoji & Symbols | `emo` |
| Kill Process | `kill` |
| Search Tab (Google Chrome) | `tab` |
| Search (Slack) | `sl` |
| Join Meeting (Zoom) | `zm` |
| Google 検索 (Quicklink) | `g` |
| リポジトリを VS Code で開く | `vs` |
| リポジトリを Ghostty で開く | `gh` |

#### 入れておくと便利な拡張

導入済み: Google Chrome / Slack / Zoom / Kill Process

未導入で候補になるもの:

- **Visual Studio Code - Recent Projects**: 最近開いたプロジェクトを検索して開く
- **Brew**: Homebrew のパッケージ検索・インストール
- **Search npm Packages**: npm パッケージ検索

## 更新のしかた

Raycast 側で Snippets / Quicklinks を追加したら、`Export Snippets` / `Export Quicklinks` で
書き出したファイルでこのリポジトリの JSON を置き換えてコミットする。
