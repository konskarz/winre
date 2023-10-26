@echo off
setlocal
if not defined _path call "%~dp0defines.bat"

REM get url list
set "_list=%TEMP%\wgetupd.txt"
cscript //nologo "%~dp0utilities\wudlg.vbs" "%_list%" "IsInstalled=0 and Type='Software'"
if %ERRORLEVEL% NEQ 0 echo There are no applicable updates & goto :_clean

REM set download directory
set "_ts=%date:~-4%%date:~3,2%%date:~0,2%%time:~0,2%%time:~3,2%%time:~6,2%"
set "_upd=%_upd%\%_ts: =0%"

REM download updates
call "%~dp0utilities\wget.bat" -i"%_list%" -N -P "%_upd%"
if not exist "%_upd%\*.*" echo Error: no files in %_upd% & goto :_clean

REM install updates
set /p "_stdin=Do you like to install updates?[y/n]: "
if "%_stdin%"=="y" dism.exe /online /add-package /packagepath:"%_upd%"

:_clean
if exist "%_list%" del /q "%_list%"

echo %~n0 completed
pause
