@echo off
setlocal

@rem デフォルトのSLEEPTIME
set /a SLEEPTIME=15
set /a STMP=%2*1

@rem 引数チェック
if "%1" == "" (
  call :usage
  exit /b
) else (
  set FILENAME=%1
  if not "%2" == "" (
    @rem 数字か?
    if not "%2" == "%STMP%" (
      echo SLEEPTIMEは数字（分）で入力してください。
      call :usage
      exit /b
    )
    @rem 0以上か?
    if "%2" LEQ "0" (
      echo SLEEPTIMEは0以上を指定してください。
      call :usage
      exit /b
    )
    set SLEEPTIME=%2
  )
)

@rem notify-send.exeがあるかチェック
if not exist "%~dp0\notify-send.exe" (
  echo "notify-send.exe"がありません。
  call :usage
  exit /b
)

@rem 指定されたファイルがあるかチェック
if not exist "%1" (
  echo %1は存在しません。
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


@rem サブルーチン
@rem 引数は分で指定。sleepがないとは…
:sleep
setlocal
set /a STIME=60 * %1
choice /C Q /D Q /T "%STIME%" >nul
exit /b

@rem ポップアップ表示(コマンドプロンプトにも表示)
:notify
setlocal
set TITLE=[%date% %time%]
set TEXT=%SLEEPTIME%分で書いた文字数: だいたい%1文字
echo %TITLE% %TEXT%
%~dp0\notify-send "%TITLE%" "%TEXT%"
exit /b

:usage
echo usage: %~xn0 [FILENAME] [SLEEPTIME] 1>&2
echo SLEEPTIME（分）は省略可能です。 1>&2
exit /b
