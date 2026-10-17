#!/bin/bash

# CachyOS で Docker が外に出られない・内蔵HDDが見えないときの切り分け。
# 設定は変更せず、結果を表示するだけ。対処は doc/cachyos/README.md を参照。
#
# 使い方: bash scripts/cachyos-docker-check.sh [HDDのマウント先]
#   例:   bash scripts/cachyos-docker-check.sh /mnt/hdd

set -uo pipefail

HDD_MOUNT="${1:-/mnt/hdd}"
IMAGE="busybox"

section() {
    printf '\n===== %s =====\n' "$1"
}

ok() { echo "✅ $*"; }
ng() { echo "❌ $*"; }
info() { echo "   $*"; }

section "カーネル（更新後に再起動していないとネットワークが壊れる）"
running=$(uname -r)
info "実行中:       $running"
info "インストール: $(pacman -Q linux-cachyos 2>/dev/null || echo 不明)"
# Arch 系はカーネル更新で旧カーネルのモジュールが消えるので、これで再起動漏れを判定できる
if [[ -d "/usr/lib/modules/$running" ]]; then
    ok "実行中カーネルのモジュールがあります"
else
    ng "/usr/lib/modules/$running がありません。再起動が必要です"
fi

section "Docker デーモン"
if systemctl is-active --quiet docker; then
    ok "docker は動いています"
else
    ng "docker が動いていません（sudo systemctl enable --now docker）"
fi
if [[ -f /etc/docker/daemon.json ]]; then
    info "/etc/docker/daemon.json:"
    sed 's/^/     /' /etc/docker/daemon.json
else
    info "/etc/docker/daemon.json はありません"
fi

section "IP 転送"
if [[ "$(sysctl -n net.ipv4.ip_forward)" == "1" ]]; then
    ok "net.ipv4.ip_forward = 1"
else
    ng "net.ipv4.ip_forward = 0（コンテナの通信が外に転送されません）"
fi

section "ファイアウォール"
if command -v ufw >/dev/null; then
    sudo ufw status | sed 's/^/   /'
    if [[ -f /etc/default/ufw ]]; then
        info "$(grep '^DEFAULT_FORWARD_POLICY' /etc/default/ufw)"
        if grep -q '^DEFAULT_FORWARD_POLICY="DROP"' /etc/default/ufw; then
            ng "ufw が FORWARD を DROP しています（コンテナの通信が止まる原因になります）"
        fi
    fi
else
    info "ufw はありません"
fi
if systemctl is-active --quiet firewalld; then
    info "firewalld が動いています"
else
    info "firewalld は動いていません"
fi

section "ホスト自身の通信"
if ping -c1 -W3 8.8.8.8 >/dev/null 2>&1; then
    ok "ホストから 8.8.8.8 に届きます"
else
    ng "ホスト自身が外に出られません（Docker 以前の問題です）"
fi
info "/etc/resolv.conf:"
grep -v '^#' /etc/resolv.conf | sed 's/^/     /'

section "コンテナからの通信"
if docker run --rm "$IMAGE" ping -c1 -W3 8.8.8.8 >/dev/null 2>&1; then
    ok "コンテナから IP で外に届きます"
    if docker run --rm "$IMAGE" nslookup google.com >/dev/null 2>&1; then
        ok "コンテナで名前解決できます"
    else
        ng "IP は届くのに名前解決だけ失敗しています（DNS の問題）"
    fi
else
    ng "コンテナから IP で外に届きません（ファイアウォール / IP 転送 / カーネルを確認）"
fi

section "ディスク"
lsblk -f | sed 's/^/   /'
info ""
info "/etc/fstab（コメント除く）:"
grep -v '^\s*#' /etc/fstab | grep -v '^\s*$' | sed 's/^/     /'

section "HDD のマウント先: $HDD_MOUNT"
if mountpoint -q "$HDD_MOUNT"; then
    ok "$HDD_MOUNT はマウントされています"
    if docker run --rm -v "$HDD_MOUNT:/data" "$IMAGE" ls /data >/dev/null 2>&1; then
        ok "コンテナから $HDD_MOUNT が見えます"
    else
        ng "コンテナから $HDD_MOUNT を読めません（権限を確認）"
    fi
else
    ng "$HDD_MOUNT はマウントされていません（/etc/fstab に書いて sudo mount -a）"
fi
