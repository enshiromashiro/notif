@echo off

@rem ポップアップを出す時間(分)
set /a SLEEPTIME=1

call "%~dp0notif.bat" "%1" %SLEEPTIME%
pause