#!/bin/bash

# システム以外のディスク（内蔵の別 HDD など）を /etc/fstab に登録し、起動時に自動でマウントされるようにする。
# 手順の説明は doc/cachyos/README.md を参照。
#
# 使い方: bash scripts/cachyos-hdd-mount.sh [マウント先]
#   例:   bash scripts/cachyos-hdd-mount.sh /mnt/hdd
#   省略すると /mnt/hdd。候補が複数あるときは番号で選ぶ
#
# /etc/fstab は /etc/fstab.bak に退避してから追記し、mount -a が失敗したら元に戻す。

set -uo pipefail

TARGET="${1:-/mnt/hdd}"
IMAGE="busybox"

section() {
    printf '\n===== %s =====\n' "$1"
}

ok() { echo "✅ $*"; }
ng() { echo "❌ $*"; }
info() { echo "   $*"; }

# システムが入っているディスク以外の、ファイルシステムがあってマウントされていないパーティション
find_candidates() {
    local root_source root_disk name type fstype disk
    root_source=$(findmnt -no SOURCE / | sed 's/\[.*//')
    root_disk=$(lsblk -no PKNAME "$root_source" | head -n1)
    # lsblk の列出力は空欄で列がずれるので、デバイスごとに1項目ずつ取る
    for name in $(lsblk -lpno NAME); do
        type=$(lsblk -dno TYPE "$name")
        [[ "$type" == "part" || "$type" == "disk" ]] || continue
        fstype=$(lsblk -dno FSTYPE "$name")
        [[ -n "$fstype" && -n "$(lsblk -dno UUID "$name")" ]] || continue
        [[ -z "$(lsblk -dno MOUNTPOINTS "$name" | tr -d '[:space:]')" ]] || continue
        [[ "$fstype" == "swap" || "$fstype" == "crypto_LUKS" || "$fstype" == "LVM2_member" ]] && continue
        disk=$(lsblk -dno PKNAME "$name")
        [[ "${disk:-$(basename "$name")}" != "$root_disk" ]] || continue
        echo "$name"
    done
}

section "マウントされていないディスク"
mapfile -t candidates < <(find_candidates)
if [[ ${#candidates[@]} -eq 0 ]]; then
    ng "候補がありません。lsblk -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINTS で確認してください"
    exit 1
fi
for i in "${!candidates[@]}"; do
    info "[$((i + 1))] $(lsblk -no NAME,SIZE,FSTYPE,LABEL "${candidates[$i]}" | head -n1)"
done

if [[ ${#candidates[@]} -eq 1 ]]; then
    device="${candidates[0]}"
else
    read -rp "番号を選んでください: " n
    device="${candidates[$((n - 1))]:-}"
    [[ -n "$device" ]] || { ng "番号が正しくありません"; exit 1; }
fi

uuid=$(lsblk -no UUID "$device")
fstype=$(lsblk -no FSTYPE "$device")
uid=$(id -u)
gid=$(id -g)

# NTFS / exFAT / FAT は所有者の概念が無いので、uid/gid を指定しないと root 所有になり書き込めない
case "$fstype" in
    ext4 | btrfs | xfs) line="UUID=$uuid  $TARGET  $fstype  defaults,nofail  0 2" ;;
    ntfs) line="UUID=$uuid  $TARGET  ntfs3  uid=$uid,gid=$gid,nofail  0 0" ;;
    exfat | vfat) line="UUID=$uuid  $TARGET  $fstype  uid=$uid,gid=$gid,nofail  0 0" ;;
    *) ng "$fstype は対応していません。doc/cachyos/README.md を見て手で追記してください"; exit 1 ;;
esac

section "/etc/fstab への追記"
appended=0
if grep -q "^UUID=$uuid" /etc/fstab; then
    info "既に登録されています: $(grep "^UUID=$uuid" /etc/fstab)"
else
    info "追記する行: $line"
    read -rp "追記してよいですか？ [y/N] " answer
    [[ "$answer" == "y" ]] || { info "中止しました"; exit 0; }
    sudo cp /etc/fstab /etc/fstab.bak
    echo "$line" | sudo tee -a /etc/fstab >/dev/null
    appended=1
    ok "追記しました（元のファイルは /etc/fstab.bak）"
fi

section "マウント"
sudo mkdir -p "$TARGET"
sudo systemctl daemon-reload
if sudo mount -a; then
    ok "mount -a が通りました"
elif [[ "$appended" == "1" ]]; then
    sudo cp /etc/fstab.bak /etc/fstab
    sudo systemctl daemon-reload
    ng "mount -a が失敗したので /etc/fstab を元に戻しました"
    exit 1
else
    ng "mount -a が失敗しました。/etc/fstab を確認してください"
    exit 1
fi
if mountpoint -q "$TARGET"; then
    ok "$TARGET にマウントされています"
else
    ng "$TARGET にマウントされていません"
    exit 1
fi

section "コンテナから見えるか"
if docker run --rm -v "$TARGET:/data" "$IMAGE" ls /data >/dev/null 2>&1; then
    ok "コンテナから $TARGET が見えます（-v $TARGET:/data で渡せます）"
else
    ng "コンテナから $TARGET を読めません（権限を確認してください）"
fi
