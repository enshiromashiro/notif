# notif

指定したテキストファイルの文字数増減を定期的にポップアップ通知する。
Linux/Windows両用。

![Windowsでの動作イメージ](https://github.com/subaru45/notif/wiki/images/notif-win.png)

* Windowsでの動作イメージ

![Linuxでの動作イメージ](https://github.com/subaru45/notif/wiki/images/notif-linux.png)

* Linuxでの動作イメージ

## 必要なもの

### Windowsの場合

1. Windows PowerShell (Vista以降なら標準で入ってます)

XPでも、PowerShellを追加でインストールすることが可能です。
(サポート期限の切れたOSなので、あまりお薦めはしません)


### Linuxの場合

1. bash
2. libnotify (notify-sendコマンド)


## インストール

### Windowsの場合

1. <http://github.com/subaru45/notif>ページ右側の`Download ZIP`からダウンロードする
2. ダウンロードしたZIPファイルを好きな場所に解凍する


### Linuxの場合

`git clone`したあと`notif.sh`をPATHの通った場所に置く


## 使い方


### 注意事項

ファイルを定期的に読んで文字数をカウントするため、__ファイルをこまめに保存する必要__があることに注意してください。
こまめにセーブ、これ鉄則。


### Windowsの場合

#### 起動方法

`notif.ps1`を右クリックして「powershellで起動」を選ぶと起動します。

あるいは、右クリックでの起動が面倒な場合、次のようにしてショートカットをつくります。

1. `notif.ps1`のショートカットをデスクトップにつくる
2. つくったショートカットを右クリックし、「プロパティ」を選ぶ
3. 「ショートカット」タブを開き、「リンク先」に書かれたパスを次のように変更する:
  1. パスをダブルクォートで囲む
  2. パスの前に`powershell`と入力し、__パスとの間に半角スペース__を入れる
  * 例：リンク先に`C:\notif\notif.ps1`とある場合`powershell "C:\notif\notif.ps1"`に変更する

#### 使用方法

測りたいテキストファイルをウィンドウにドラッグ&ドロップすると、計測開始です。
次回計測までの時間はタイトルバーに表示されます。


#### 初回だけ実行する操作

Windows版notifはPowerShellスクリプトとして書かれていますが、
PowerShellスクリプトはデフォルトの設定では実行できないようになっています。
セキュリティリスクを抑えるためです。

そこでまず、スクリプトを実行できるように設定を変える必要があります。

まず、PowerShellを管理者権限で起動します。
Windows XPでは、管理者権限のあるユーザでWindows PowerShellを起動すればいいです。

Windows Vista/7では、スタートメニューの「アクセサリ」→「Windows PowerShell」にある「Windows PowerShell」を右クリックし、「管理者として実行」を選びます。

Windows 8では、マウスポインタをデスクトップ右上に持っていき「チャーム」を表示します。
つぎに、検索を選び「powershell」と入力し、検索結果に出てきた"Windows PowerShell"のアイコンを右クリックします。
するとメニューに「管理者として実行」が現れるので、それをクリックします。

![PowerShellの起動(管理者権限)](https://raw.githubusercontent.com/wiki/subaru45/notif/images/psh-admin.png)

* PowerShellの起動 (Windows Vista)

青い画面が起動したら、そこに次のように打ちこみます:

    > Set-ExecutionPolicy RemoteSigned

すると、実行ポリシーを変更するかどうか訊かれるので「Y」を入力します。

![実行ポリシーを変更したところ](https://raw.githubusercontent.com/wiki/subaru45/notif/images/psh-policy.png)

* 実行ポリシーを変更したところ

これで、PowerShellスクリプトを実行できるようになりました。
ためしにnotifを起動してみてください。


### Linuxの場合

ターミナルで次のように打つ:

    $ notif.sh textfile.txt&

終了するときは`kill`するか、`Ctrl+C`。

ポップアップ間隔を指定したいときは`-t`オプションを指定する:

    $ notif.sh -t 1h textfile.txt&

指定方法は`sleep`コマンドの時間指定方法に準ずる。
ポップアップ間隔はデフォルトで15分(`15m`)。


## ライセンス

MITライセンス
