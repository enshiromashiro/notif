@echo off

@rem �|�b�v�A�b�v���o������(��)
set /a SLEEPTIME=15

call "%~dp0notif.bat" "%1" %SLEEPTIME%
pause