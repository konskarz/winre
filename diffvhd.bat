@echo off
setlocal
if not defined _path call "%~dp0defines.bat"

REM set vhd
if exist "%_boot%\*.vhd" goto :_setname

echo Error: no images found in %_boot%
pause & goto :eof

:_setname
echo Available images:
for %%G in ("%_boot%\*.vhd") do echo %%~nG
set /p "_selectedname=Please enter the image name: "
if "x%_selectedname%"=="x" if exist "%_vhd%" goto :_main
if not exist "%_boot%\%_selectedname%.vhd" goto :_setname

set "_vhd=%_boot%\%_selectedname%.vhd"

:_main
for %%G in ("%_vhd%") do set "_diff=%%~dG%%~pG%%~nG-diff%%~xG"
if exist "%_diff%" del /q "%_diff%"

set "_diskpart=%TEMP%\create.diskpart"
> %_diskpart% echo create vdisk file=%_diff% parent=%_vhd%
>> %_diskpart% echo exit
diskpart.exe /s %_diskpart%
del /q "%_diskpart%"

echo %~n0 completed
pause