
@echo off

@rem notif.ps1���N�����邾���̃o�b�`

@rem PowerShell�̃X�N���v�g�ɂ̓h���b�O&�h���b�v�ł��Ȃ�����


powershell "%~dp0notif.ps1" "%~f1"



if not %ERRORLEVEL% == 0 (

  pause

)
