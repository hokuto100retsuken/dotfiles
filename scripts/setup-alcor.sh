#!/bin/bash

set -euo pipefail

# alcor（Hyprland のデスクトップ環境）を clone・更新して、そのインストーラを実行する。
# alcor はチェックアウトをそのまま実行時のパスにするので、clone 先を動かすと壊れる。

ALCOR_REPO="https://github.com/hokuto100retsuken/alcor.git"
ALCOR_DIR="${ALCOR_DIR:-$HOME/src/github.com/hokuto100retsuken/alcor}"

if [[ -d "$ALCOR_DIR/.git" ]]; then
    echo "  [UPDATE] $ALCOR_DIR"
    git -C "$ALCOR_DIR" pull --ff-only
else
    echo "  [CLONE] $ALCOR_REPO -> $ALCOR_DIR"
    mkdir -p "$(dirname "$ALCOR_DIR")"
    git clone "$ALCOR_REPO" "$ALCOR_DIR"
fi

"$ALCOR_DIR/setup/alcor-install" "$@"
