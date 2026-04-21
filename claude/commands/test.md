指定されたファイルに関連するテストを実行する。

## 手順
1. プロジェクトのテスト構成を把握する
   - `package.json` / `Gemfile` / `Cargo.toml` / `pyproject.toml` 等とテストディレクトリを確認し、実行コマンドと命名規約を特定する
2. 引数で渡されたファイルパスから、対応するテストファイルを推測する
   - プロジェクトの命名規約に従う（例: Rails `app/models/foo.rb` → `spec/models/foo_spec.rb`、Node `src/foo.ts` → `src/foo.test.ts` or `test/foo.test.ts`）
   - テストファイルが直接指定された場合はそのまま使う
   - 推測できない場合はユーザーに確認する
3. プロジェクトのテスト実行方法でテストを実行する
4. 失敗したテストがあれば原因を分析して修正案を提示する

$ARGUMENTS
