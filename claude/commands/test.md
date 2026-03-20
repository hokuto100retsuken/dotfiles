指定されたファイルに関連するテストを実行する。

## 手順
1. 引数で渡されたファイルパスから、対応するテストファイルを推測する
   - `app/models/foo.rb` → `spec/models/foo_spec.rb`
   - `app/controllers/v1/foo_controller.rb` → `spec/requests/v1/foo_spec.rb`
   - テストファイルが直接指定された場合はそのまま使う
2. プロジェクトのテスト実行方法に合わせてテストを実行する
3. 失敗したテストがあれば原因を分析して修正案を提示する

$ARGUMENTS
