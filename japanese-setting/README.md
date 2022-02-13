# 入力モードのデフォルトを「ひらがな」にする

ref: https://www.neputa-note.net/2021/10/blogpost05.html



## apt sources.list ファイルの修正
root権限にスイッチ
```
sudo su -
```
```
cd /etc/apt
```
sources.listファイルのバックアップ
```
cp -p sources.list sources.list.$(/bin/date +"%Y%m%d")
```
sources.listファイル内のdeb-srcのコメントアウトを解除
```
sed -i -e "s/# deb-src/deb-src/" sources.list
```
```
exit
```

## 必要パッケージのインストール
build-essential devscriptsをインストール
```
sudo apt update
sudo apt upgrade -y
sudo apt install build-essential devscripts -y

```
fcitx-mozをビルドする時に依存するパッケージをインストール
```
sudo apt build-dep fcitx-mozc -y
```

## fcitx-mozのソース修正
fcitx-mozcのソースをダウンロード
```
apt source fcitx-mozc
```
vim でソースファイルを開く
```
vim $(find ./ -type f -name property_handler.cc)
```
83行目の false を true に修正する
```
const bool kActivatedOnLaunch = true;
```
(vim `:set number`)

## fcitxのビルド～インストール
修正したfcitx-mozcをビルドする
```
cd mozc*/
dpkg-buildpackage -us -uc -b
```
fcitx-mozcをインストールする
```
sudo dpkg -i ../mozc*.deb ../ibus-mozc*.deb
```
再ログインする

## IMシステムを「ibus」から「fcitx」に変更

Ubuntuにログインし、画面左のDockから、またはコマンド「gnome-control-center」で設定アプリを起動する。

左側の「地域と言語」を選択し、「インストールされている言語の管理」をクリックする

言語サポートウインドウが立ち上がるので、「キーボード入力に使うIMシステム」を「ibus」から「fcitx」に変更し閉じる。