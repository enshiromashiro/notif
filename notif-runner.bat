
@echo off

@rem notif.ps1を起動するだけのバッチ

@rem PowerShellのスクリプトにはドラッグ&ドロップできないため


powershell "%~dp0notif.ps1" "%~f1"



if not %ERRORLEVEL% == 0 (

  pause

)
