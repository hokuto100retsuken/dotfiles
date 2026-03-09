# nkf リファレンス

| オプション | 説明 |
|------------|------|
| `-w` | EUC-JP → UTF-8 |
| `-e` | UTF-8 → EUC-JP |
| `-Lu` | 改行 LF |
| `-Lw` | 改行 CRLF |

## トラブルシューティング

- 文字化け: `git checkout path/to/file.php` で復元
- nkf 未導入: macOS は標準、Linux は `nkf` パッケージ
