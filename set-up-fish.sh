#!/bin/bash

# fisherのインストール
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

# プラグインのインストール
fish -c "fisher install jethrokuan/z"               # z - ディレクトリジャンプ
fish -c "fisher install edc/bass"                   # bass - bashコマンド使用
fish -c "fisher install oh-my-fish/plugin-peco"     # peco - インタラクティブな検索
fish -c "fisher install oh-my-fish/plugin-grc"      # grc - カラーリング出力
fish -c "fisher install decors/fish-ghq"            # ghq - リポジトリ管理
fish -c "fisher install PatrickF1/fzf.fish"         # fzf - 履歴検索とファイル検索

echo "fishとプラグイン、およびstarshipの連携が完了しました。"
