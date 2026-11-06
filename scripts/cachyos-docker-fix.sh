#!/bin/bash

# CachyOS で Docker のコンテナが外に出られないときの対処を適用する。
# 切り分けは scripts/cachyos-docker-check.sh、手順の説明は doc/cachyos/README.md を参照。
#
# 使い方: bash scripts/cachyos-docker-fix.sh
#
# 直すもの（既に直っている項目は触らない）:
#   - ufw の DEFAULT_FORWARD_POLICY を DROP から ACCEPT にする
#   - net.ipv4.ip_forward を 1 にして永続化する
# 何かを直したときだけ docker を再起動するので、動いているコンテナは一度止まる。

set -uo pipefail

IMAGE="busybox"

section() {
    printf '\n===== %s =====\n' "$1"
}

ok() { echo "✅ $*"; }
ng() { echo "❌ $*"; }
info() { echo "   $*"; }

changed=0

section "ufw の FORWARD"
if [[ -f /etc/default/ufw ]] && grep -q '^DEFAULT_FORWARD_POLICY="DROP"' /etc/default/ufw; then
    sudo cp /etc/default/ufw /etc/default/ufw.bak
    sudo sed -i 's/^DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
    sudo ufw reload
    ok "DROP を ACCEPT に変えました（元のファイルは /etc/default/ufw.bak）"
    changed=1
else
    info "変更なし（ufw が無いか、DROP ではありません）"
fi

section "IP 転送"
if [[ "$(sysctl -n net.ipv4.ip_forward)" != "1" ]]; then
    echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-docker.conf >/dev/null
    sudo sysctl --system >/dev/null
    ok "net.ipv4.ip_forward = 1 にしました（/etc/sysctl.d/99-docker.conf）"
    changed=1
else
    info "変更なし（既に 1 です）"
fi

section "Docker の再起動"
if [[ "$changed" == "1" ]]; then
    sudo systemctl restart docker
    ok "docker を再起動しました"
else
    info "何も変えていないので再起動しません"
fi

section "コンテナからの通信"
if docker run --rm "$IMAGE" ping -c1 -W3 8.8.8.8 >/dev/null 2>&1; then
    ok "コンテナから 8.8.8.8 に届きます"
else
    ng "コンテナから 8.8.8.8 に届きません。scripts/cachyos-docker-check.sh で残りの原因を確認してください"
fi
if docker run --rm "$IMAGE" nslookup google.com >/dev/null 2>&1; then
    ok "コンテナで名前解決できます"
else
    ng "コンテナで名前解決できません。doc/cachyos/README.md の DNS の手順を確認してください"
fi
