@echo off
setlocal

@rem �f�t�H���g��SLEEPTIME
set /a SLEEPTIME=15
set /a STMP=%2*1

@rem �����`�F�b�N
if "%1" == "" (
  call :usage
  exit /b
) else (
  set FILENAME=%1
  if not "%2" == "" (
    @rem ������?
    if not "%2" == "%STMP%" (
      echo SLEEPTIME�͐����i���j�œ��͂��Ă��������B
      call :usage
      exit /b
    )
    @rem 0�ȏォ?
    if "%2" LEQ "0" (
      echo SLEEPTIME��0�ȏ���w�肵�Ă��������B
      call :usage
      exit /b
    )
    set SLEEPTIME=%2
  )
)

@rem notify-send.exe�����邩�`�F�b�N
if not exist "%~dp0\notify-send.exe" (
  echo "notify-send.exe"������܂���B
  call :usage
  exit /b
)

@rem �w�肳�ꂽ�t�@�C�������邩�`�F�b�N
if not exist "%1" (
  echo %1�͑��݂��܂���B
  call :usage
  exit /b
)


set /a CHNUM_PREV=%~z1 / 2
:loop

call :sleep %SLEEPTIME%
set /a CHNUM=%~z1 / 2
set /a CHDIFF=CHNUM - CHNUM_PREV
call :notify %CHDIFF%

goto :loop

exit /b


@rem �T�u���[�`��
@rem �����͕��Ŏw��Bsleep���Ȃ��Ƃ́c
:sleep
setlocal
set /a STIME=60 * %1
choice /C Q /D Q /T "%STIME%" >nul
exit /b

@rem �|�b�v�A�b�v�\��(�R�}���h�v�����v�g�ɂ��\��)
:notify
setlocal
set TITLE=[%date% %time%]
set TEXT=%SLEEPTIME%���ŏ�����������: ��������%1����
echo %TITLE% %TEXT%
%~dp0\notify-send "%TITLE%" "%TEXT%"
exit /b

:usage
echo usage: %~xn0 [FILENAME] [SLEEPTIME] 1>&2
echo SLEEPTIME�i���j�͏ȗ��\�ł��B 1>&2
exit /b
