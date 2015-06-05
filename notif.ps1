#### notif.ps1

[CmdletBinding()]
param(
  [string] $filename
)

[void] [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")


## constants
[string] $datefmt = "[%Y-%m-%d %H:%M:%S]"
[string] $title = "notif"
[int] $width = 400
[int] $height = 250

## variables
[int] $sleeptime = 15
[int] $char_num_prev = 0
[int] $char_num = 0
[int] $eplacedmin = 0
[int] $wrote_chnum = 0

## UI components
$form = new-object Windows.Forms.Form
$path = new-object Windows.Forms.TextBox
$numupdown = new-object Windows.Forms.NumericUpDown
$label = new-object Windows.Forms.Label
$button = new-object Windows.Forms.Button
$textlog = new-object Windows.Forms.TextBox

## other components
$notify = new-object System.Windows.Forms.NotifyIcon
$timer = $null


function main() {
  if([Threading.Thread]::CurrentThread.GetApartmentState() -eq "MTA"){
    out-default -I $MyInvocation.ScriptName
    powershell -Sta -File $MyInvocation.ScriptName
    exit
  }
  
  if ($filename -ne "") {
    $script:filename = $(get-childitem $filename).FullName
    $path.Text = $filename
    count_init
  } else {
    $path.Text = "ファイルをドラッグしてください..."
  }
  ui_init
}

function get_charnum() {
  $sum = 0
  $file = get-content $filename
  foreach ($l in $file) {
    $sum += $l.Length
  }
  return $sum
}

function notify($timeout, $title, $text, $icon) {
  $notify.BalloonTipTitle = $title
  $notify.BalloonTipText = $text
  $notify.BalloonTipIcon = $icon
  $notify.Icon = [System.Drawing.SystemIcons]::Information
  $notify.Visible = $true
  
  $notify.ShowBalloonTip($timeout)
}

function genmsg($chdiff, $chnum) {
  return ("  " + $sleeptime + "分間で書いた文字数: " + $chdiff + "文字`r`n" + `
          "  開始後" + $eplacedmin + "分で書いた文字数: " + $wrote_chnum + "文字`r`n" + `
          "  総文字数: " + $chnum + "文字")
}

function gentitle($sec) {
  return $title + " - 次回計測まで" + 
    (new-object System.TimeSpan @(0, 0, $sec))
}

function move_tail() {
  $textlog.SelectionStart = $textlog.Text.Length
  $textlog.Focus()
  $textlog.ScrolltoCaret()
}

function notify_send($diff, $num) {
  $title = get-date -uformat $datefmt
  $text = genmsg $diff $num
  
  notify 10000 $title $text "Info"
  $textlog.Text = $textlog.Text + $title + "`r`n" + $text + "`r`n"
  move_tail
}

## timer
$seconds = 0
function tick() {
  $script:seconds += 1
  
  $form.Text = gentitle ($sleeptime * 60 - $seconds)
  
  if ($seconds -ge $sleeptime * 60) {
    $script:eplacedmin += 1
    $script:seconds = 0

    $script:char_num = get_charnum
    $char_diff = $char_num - $char_num_prev
    $script:wrote_chnum += $char_diff

    notify_send $char_diff $char_num

    $script:char_num_prev = $char_num
  }
}

function start_timer() {
  if ($timer -eq $null) {
    $script:timer = new-object Windows.Forms.Timer
    $timer.Interval = 1000
    $timer.Add_Tick({tick})
  }
  $timer.Stop()
  $timer.Start()
}

function change_file($e) {
  if ($_.Data.GetDataPresent("FileDrop")) {
    $script:filename = ([String[]]$_.Data.GetData("FileDrop"))[0]
    $path.Text = $filename
    $script:seconds = 0
    count_init
  }
}

function count_init() {
  $textlog.Text = $textlog.Text + "* " + $filename + "`r`n"
  move_tail
  $script:char_num_prev = get_charnum
  $script:char_num = 0
  start_timer
}

$cnt = 0
function foo(){
  $script:cnt += 1
  if ($cnt -eq 8) {
    $script:cnt = 0
    notify 10000 "こらっ！" "遊んでないで書きなさい！" "Error"
  } elseif ($cnt -eq 5) {
    notify 10000 "注意" "何もありませんよ？" "Info"
  } elseif ($cnt -ge 2) {
    notify 10000 "注意！" "ボタンではありませんってば！" "Warning"
  } else {
    notify 10000 "注意" "ボタンではありません。" "Info"
  }
}

function ui_init() {
  $vpanel = new-object Windows.Forms.FlowLayoutPanel
  $hpanel = new-object Windows.Forms.FlowLayoutPanel
  
  $font1 = new-object Drawing.Font @("メイリオ", 12)
  $font2 = new-object Drawing.Font @("メイリオ", 8)


  $path.ReadOnly = $true
  $path.AutoSize = $true
  $path.Dock = "Fill"
  $path.Font = $font2

  $numupdown.Value = $sleeptime
  $numupdown.Minimum = 1
  $numupdown.Maximum = 240
  $numupdown.Width = 70
  $numupdown.Font = $font1

  $label.Text = "分間隔でお知らせ"
  $label.TextAlign = "MiddleLeft"
  $label.Width = 220
  $label.Dock = "Fill"
  $label.Font = $font1
  $label.Add_Click({foo})

  $button.Text = "間隔を変更"
  $button.AutoSize = $true
  $button.Dock = "Fill"
  $button.Font = $font1
  $button.Add_Click({$script:sleeptime = $numupdown.Value})

  $hpanel.MinimumSize = new-object System.Drawing.Size @($width, $numupdown.Height)
  $hpanel.AutoSize = $true
  $hpanel.FlowDirection = "LeftToRight"
  $hpanel.Controls.Add($numupdown)
  $hpanel.Controls.Add($label)
  $hpanel.Controls.Add($button)
  
  $textlog.Multiline = $true
  $textlog.Scrollbars = "Vertical"
  $textlog.ReadOnly = $true
  $textlog.AutoSize = $true
  $textlog.Height = $height - $path.Height - $numupdown.Height
  $textlog.Dock = "Fill"
  $textlog.Font = $font2

  $vpanel.MinimumSize = new-object System.Drawing.Size @($width, $height)
  $vpanel.AutoSize = $true
  $vpanel.FlowDirection = "TopDown"
  $vpanel.Controls.Add($path)
  $vpanel.Controls.Add($hpanel)
  $vpanel.Controls.Add($textlog)

  $form.Text = $title
  $form.MaximizeBox = $false
  $form.FormBorderStyle = "FixedSingle"

  $form.AllowDrop = $true
  $form.Add_DragEnter({$_.Effect = "All"})
  $form.Add_DragDrop({change_file $_})
  $form.AutoSize = $true
  $form.Controls.Add($vpanel)
  $form.ShowDialog()
}

. main
