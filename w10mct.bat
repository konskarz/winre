@echo off
setlocal
if not defined _path call "%~dp0defines.bat"

set "_tfile=%_tools%\w10mct.exe"
if exist "%_tfile%" del /q "%_tfile%"

set "_url=http://go.microsoft.com/fwlink/?LinkId=691209"
if not exist "%_tools%" md "%_tools%"
cscript //nologo "%~dp0utilities\getbin.vbs" "%_url%" "%_tfile%"
if not exist "%_tfile%" echo Error: %_tfile% not found & exit /b 1

%_tfile%
