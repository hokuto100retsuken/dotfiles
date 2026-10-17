# CachyOS の Docker トラブル対処

CachyOS 機（Core i7-4770 / メモリ 24GB）で起きた、次の2つの症状の対処メモ。

- コンテナから外に通信できない
- 内蔵の別 HDD がコンテナから見えない

## まず切り分けスクリプトを回す

```bash
bash scripts/cachyos-docker-check.sh /mnt/hdd   # 引数は HDD のマウント先
```

設定は変更せず、どこで止まっているかを ✅ / ❌ で表示するだけ。❌ が出た項目を下の対処で直す。

## 外に通信できない

### 1. 再起動していない

CachyOS はカーネルの更新が頻繁にある。更新後に再起動していないと、Docker が使うネットワークのカーネルモジュールを読み込めない。
`/usr/lib/modules/$(uname -r)` が無ければ再起動が必要。

### 2. ufw がコンテナの通信を止めている

ufw は既定で FORWARD を DROP するので、コンテナの通信が外に出ない。

```bash
sudo sed -i 's/^DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
sudo ufw reload
sudo systemctl restart docker
```

firewalld を使っている場合は、`sudo systemctl stop firewalld` で一時的に止め、通るようになるかで原因かどうかを確認する。

### 3. IP 転送が無効

```bash
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-docker.conf
sudo sysctl --system
```

### 4. IP では届くのに名前解決だけ失敗する（DNS）

`/etc/docker/daemon.json` に `dns` を追加する。ファイルが既にある場合は上書きせず、中身を見てから追記する。

```json
{
  "dns": ["8.8.8.8", "1.1.1.1"]
}
```

```bash
sudo systemctl restart docker
```

## HDD がコンテナから見えない

コンテナは HDD を直接見られない。**ホストでマウントしてから、そのフォルダをコンテナに渡す。**

KDE のファイルマネージャーで開いたときの `/run/media/ユーザー名/...` へのマウントはクリックしたときだけ行われる。
起動直後のコンテナからは空に見えるので、`/etc/fstab` に書いて起動時に自動でマウントする。

```bash
lsblk -f                # UUID とファイルシステムを確認
sudo mkdir -p /mnt/hdd
```

`/etc/fstab` に、ファイルシステムに合わせてどちらかを追記する。`nofail` を付けると、HDD が無くても起動が止まらない。

```
# ext4 / btrfs
UUID=xxxx-xxxx  /mnt/hdd  ext4   defaults,nofail            0 2

# NTFS（Windows で使っていた HDD）
UUID=xxxx-xxxx  /mnt/hdd  ntfs3  uid=1000,gid=1000,nofail   0 0
```

```bash
sudo systemctl daemon-reload
sudo mount -a
docker run --rm -v /mnt/hdd:/data busybox ls /data   # コンテナから見えるか
```

docker compose では `volumes:` に書く。

```yaml
volumes:
  - /mnt/hdd:/data
```
