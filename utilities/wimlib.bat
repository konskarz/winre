@echo off
setlocal
if not defined _path call "%~dp0..\defines.bat"

set "_thome=%_tools%\wimlib\%PROCESSOR_ARCHITECTURE%"
set "_tfile=%_thome%\wimlib-imagex.exe"
if exist "%_tfile%" goto :_main

set "_src=%_tools%\wimlib-%PROCESSOR_ARCHITECTURE%.zip"
if exist "%_src%" goto :_extract

set "_url=http://wimlib.net/downloads/wimlib-1.11.0-windows-i686-bin.zip"
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "_url=http://wimlib.net/downloads/wimlib-1.11.0-windows-x86_64-bin.zip"
if not exist "%_tools%" md "%_tools%"
cscript //nologo "%~dp0getbin.vbs" "%_url%" "%_src%"
if not exist "%_src%" echo Error: %_src% not found & exit /b 1

:_extract
if not exist "%_thome%" md "%_thome%"
cscript //nologo "%~dp0unzip.vbs" "%_src%" "%_thome%"
if not exist "%_tfile%" echo Error: %_tfile% not found & exit /b 1

:_main
"%_tfile%" %*
