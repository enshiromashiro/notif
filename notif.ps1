#### notif.ps1

[CmdletBinding()]
param(
  [parameter(Mandatory=$true)]
  [string] $filename
)

[void] [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")


## constants
[string] $datefmt = "[%Y-%m-%d %H:%M:%S]"

## variables
[int] $sleeptime=15
[int] $char_num_prev=0
[int] $char_num=0


function main() {
  init
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

$notify = new-object System.Windows.Forms.NotifyIcon
function notify($timeout, $title, $text, $icon) {
  $notify.BalloonTipTitle = $title
  $notify.BalloonTipText = $text
  $notify.BalloonTipIcon = $icon
  $notify.Icon = [System.Drawing.SystemIcons]::Information
  $notify.Visible = $true
  
  $notify.ShowBalloonTip($timeout)
}

function genmsg($chdiff, $chnum) {
  return ($sleeptime.ToString() `
           + "分で書いた文字数: " + $chdiff + "文字`r`n" `
           + "総文字数: " + $chnum + "文字")
}

function notify_send() {
  $script:char_num = get_charnum
  $char_diff = $char_num - $char_num_prev
  
  $title = get-date -uformat $datefmt
  $text = genmsg $char_diff $char_num
  
  notify 10000 $title $text "Info"
  $textlog.Text = $textlog.Text + $title + "`r`n" + $text + "`r`n"
  $textlog.SelectionStart = $textlog.Text.Length
  $textlog.Focus()
  $textlog.ScrolltoCaret()
  
  $script:char_num_prev = $char_num
}

## timer
$minutes = 0
function tick() {
  $script:minutes += 1
  if ($minutes -ge $sleeptime) {
    $script:minutes = 0
    notify_send
  }
}

function start_timer() {
  $timer = new-object Windows.Forms.Timer
  $timer.Interval = 60000
  $timer.Add_Tick({tick})
  $timer.Start()
}

function init() {
  if (-not (test-path $filename)) {
    out-string -i ($filename + "が存在しません")
    exit 1
  }
  $script:char_num_prev = get_charnum
  start_timer
}

$code=@'
$cnt = 0
function foo(){
  $script:cnt += 1
  if ($cnt -eq 8) {
    $script:cnt = 0
    notify 10000 "ほらね" $code "Error"
  } elseif ($cnt -eq 5) {
    notify 10000 "注意" "何もありませんよ？" "Info"
  } elseif ($cnt -ge 2) {
    notify 10000 "注意！" "ボタンではありませんってば！" "Warning"
  } else {
    notify 10000 "注意" "ボタンではありません。" "Info"
  }
}
'@
$cnt = 0
function foo(){
  $script:cnt += 1
  if ($cnt -eq 8) {
    $script:cnt = 0
    notify 10000 "ほらね" $code "Error"
  } elseif ($cnt -eq 5) {
    notify 10000 "注意" "何もありませんよ？" "Info"
  } elseif ($cnt -ge 2) {
    notify 10000 "注意！" "ボタンではありませんってば！" "Warning"
  } else {
    notify 10000 "注意" "ボタンではありません。" "Info"
  }
}

function ui_init() {
  $form = new-object Windows.Forms.Form
  $panel = new-object Windows.Forms.Panel
  $numupdown = new-object Windows.Forms.NumericUpDown
  $label = new-object Windows.Forms.Label
  $button = new-object Windows.Forms.Button
  $script:textlog = new-object Windows.Forms.TextBox
  $font1 = new-object Drawing.Font @("メイリオ", 12)
  $font2 = new-object Drawing.Font @("メイリオ", 8)
    
  $numupdown.Value = $sleeptime
  $numupdown.Minimum = 1
  $numupdown.Maximum = 240
  $numupdown.Width = 70
  $numupdown.Anchor = "Left"
  $numupdown.Font = $font1
  
  $label.Text = "分間隔でお知らせ"
  $label.Left = $numupdown.Width
  $label.Width = 250 - $numupdown.Width
  $label.Height = $numupdown.Height
  $label.TextAlign = "MiddleLeft"
  $label.Anchor = "Left"
  $label.Font = $font1
  $label.Add_Click({foo})
  
  $panel.Dock = "Top"
  $panel.Size = new-object Drawing.Size @(300, $numupdown.Height)
  $panel.Controls.Add($numupdown)
  $panel.Controls.Add($label)

  $button.Text = "間隔を変更"
  $button.Top = $numupdown.Height
  $button.Size = new-object Drawing.Size @(150, $numupdown.Height)
  $button.Font = $font1
  $button.Add_Click({$script:sleeptime = $numupdown.Value})
  
  $textlog.Top = $numupdown.Height + $button.Height
  $textlog.Width = 380
  $textlog.Height = $numupdown.Height * 4
  $textlog.Multiline = $true
  $textlog.Scrollbars = "Vertical"
  $textlog.ReadOnly = $true
  $textlog.Font = $font2

  $form.Width = 380
  $form.Height = $numupdown.Height * 7
  $form.Text = "notif"
  $form.MaximizeBox = $false
  $form.FormBorderStyle = "FixedSingle"

  $form.Controls.Add($panel)
  $form.Controls.Add($button)
  $form.Controls.Add($textlog)
  
  $form.ShowDialog()
}

. main
