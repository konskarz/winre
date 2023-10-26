@echo off
setlocal
if not defined _path call "%~dp0..\defines.bat"

set "_thome=%_tools%\wget"
set "_tfile=%_thome%\bin\wget.exe"
if exist "%_tfile%" goto :_main

set "_src=%_tools%\wget.zip"
if exist "%_src%" goto :_extract

set "_url=http://downloads.sourceforge.net/ezwinports/wget-1.16.1-w32-bin.zip"
if not exist "%_tools%" md "%_tools%"
cscript //nologo "%~dp0getbin.vbs" "%_url%" "%_src%"
if not exist "%_src%" echo Error: %_src% not found & exit /b 1

:_extract
if not exist "%_thome%" md "%_thome%"
cscript //nologo "%~dp0unzip.vbs" "%_src%" "%_thome%"
if not exist "%_tfile%" echo Error: %_tfile% not found & exit /b 1

:_main
"%_tfile%" %*
