#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR"

echo "=========================================="
echo "dotfiles セットアップを開始します"
echo "OS: $(uname -s)"
echo "=========================================="
echo ""

# パッケージインストール
echo "📦 パッケージのインストールを開始..."
if bash setup-installs.sh; then
    echo "✓ パッケージのインストールが完了しました"
else
    echo "⚠ パッケージのインストール中にエラーが発生しました"
    echo "続行しますか？ (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "セットアップを中断しました"
        exit 1
    fi
fi

echo ""

# dotfiles設定
echo "🔗 dotfilesのシンボリックリンクを作成..."
if bash setup-dotfiles.sh; then
    echo "✓ dotfilesの設定が完了しました"
else
    echo "✗ dotfilesの設定中にエラーが発生しました"
    exit 1
fi

echo ""
echo "=========================================="
echo "✓ セットアップが正常に完了しました！"
echo "=========================================="
echo ""
echo "次のステップ:"
echo "1. ターミナルを再起動してください"
echo "2. fishシェルが起動することを確認してください"
