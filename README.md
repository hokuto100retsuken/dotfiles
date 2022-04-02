# ubuntu setting

## Ubuntuをちょっと使いやすくする設定集
ref: https://qiita.com/karaage0703/items/705f1b750c486f00d554

- 最低限のソフトインストール
  ```
  $ sudo apt update
  $ sudo apt -y install git
  $ sudo apt -y install curl
  ```
- ディレクトリの英語化
  ```
  LANG=C xdg-user-dirs-gtk-update
  ```
- キーボード設定する<br>
  ref: https://linuxfan.info/capslock-ctrl

  ```
  setxkbmap -layout us -option ctrl:nocaps
  ```

- Vim
  ```
  sudo apt install -y vim
  ```
  
- brew install

https://brew.sh/index_ja

- ghq

```
brew install ghq
git config --global ghq.root '~/src'
```

- ctrl + a
 ctrl + aで先頭に移動できない場合
 .zshrcに`bindkey -e` を追加すると問題ないみたい
 
 https://stackoverflow.com/questions/23128353/zsh-shortcut-ctrl-a-not-working
 
 問題が出るまではこれで様子見
