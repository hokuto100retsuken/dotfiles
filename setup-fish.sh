#!/bin/bash

set -euo pipefail

# fisherのインストール
if ! fish -c "type -q fisher" 2>/dev/null; then
    echo "Installing fisher..."
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
fi

# fish_plugins に基づいてプラグインをインストール
echo "Installing fish plugins from fish_plugins..."
fish -c "fisher update"

echo "fishプラグインのセットアップが完了しました。"
