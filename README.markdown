# notif

指定したテキストファイルの文字数増減を定期的にポップアップ通知する。
Linux/Windows両用。

![Linuxでの動作イメージ](https://github.com/subaru45/notif/wiki/images/notif-linux.png))

![Windowsでの動作イメージ](https://github.com/subaru45/notif/wiki/images/notif-win.png)


## 必要なもの

### Linuxの場合

1. bash
2. libnotify (notify-sendコマンド)


### Windowsの場合

1. [notify-send for Windows](http://vaskovsky.ru/notify-send/en/)


## インストール

### Linuxの場合

`git clone`したあと`notif.sh`をPATHの通った場所に置く。

### Windowsの場合

1. <http://github.com/subaru45/notif>ページ右側の`Download ZIP`からダウンロードする
2. ダウンロードしたZIPファイルを好きな場所に解凍する
3. [ここ](http://vaskovsky.ru/notify-send/en/)からnotify-sendをダウンロードして、`notif.bat`と同じフォルダに置く


## 使い方

### Linuxの場合

ターミナルで次のように打つ:

    $ notif.sh textfile.txt&

終了するときは`kill`するか、`Ctrl+C`。

ポップアップ間隔を指定したいときは`-t`オプションを指定する:

    $ notif.sh -t 1h textfile.txt&

指定方法は`sleep`コマンドの時間指定方法に準ずる。
ポップアップ間隔はデフォルトで15分(`15m`)。


### Windowsの場合

2通りの使い方がある。

1つ目は、`notif-runner.bat`にポップアップ間隔(分)を書いてショートカットを作っておき、そのショートカットに測りたいテキストファイルをドラッグ&ドロップする方法。

2つ目は、コマンドプロンプトで毎回コマンドを叩く方法。

#### 1. ショートカットをつくるやり方

ショートカットをつくる前に、設定の編集をする。

`notif-runner.bat`をメモ帳で開いて、以下の行の数字の部分(`15`の部分)を好きなように変更する。
ここに書いた数字が、ポップアップの表示される間隔(分)となる。
変更はしなくてもよい。

    @rem ポップアップを出す時間(分)
    set /a SLEEPTIME=15

つぎに、`notif-runner.bat`のショートカットをデスクトップなどにつくる。

使うときは、文字数を見張ってほしいファイルを、さきほどつくったショートカットにドラッグ&ドロップする。
終了するには、黒いウインドウの×ボタンを押せばよい。


#### 2. コマンドプロンプトで叩くやり方

コマンドプロンプトで叩く場合、Linuxと引数の順序等が異なるので注意すること。

ファイル名のみ指定する場合(ポップアップ間隔は15分)は

    > notif.bat textfile.txt

と打つ。

ポップアップ間隔(分単位)を指定したい場合(この例では30分)は

    > notif.bat textfile.txt 30

と打つ。


## 注意

ファイルを定期的に読んで文字数をカウントするため、__こまめに保存する必要__があることに注意。


## ライセンス

MITライセンス
