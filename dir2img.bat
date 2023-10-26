@echo off
setlocal
if not defined _path call "%~dp0defines.bat"
set "_name=windows"

REM fsutil fsinfo drives
echo list volume | diskpart

:_setletter
set /p "_letter=Please select the drive letter: "
if not exist %_letter%:\ goto :_setletter

if not exist "%_reimgd%\*.wim" goto :_setname

echo Existing images:
for %%G in ("%_reimgd%\*.wim") do echo %%~nG

:_setname
set /p "_selectedname=Please enter the image name: "
if "x%_selectedname%"=="x" if not exist "%_reimgf%" goto :_main
if "x%_selectedname%"=="x" goto :_setname

set "_reimgf=%_reimgd%\%_selectedname%.wim"
REM use default name with default image
if not "%_selectedname%"=="install" set "_name=%_selectedname%"
if not exist "%_reimgf%" goto :_main

REM rename existing
for %%G in ("%_reimgf%") do set "_fdt=%%~tG"
set "_fdt=%_fdt:~6,4%%_fdt:~3,2%%_fdt:~0,2%%_fdt:~11,2%%_fdt:~14,2%"
set "_renamed=%_selectedname%%_fdt: =0%.wim"
echo Rename: %_reimgf% to %_renamed%
ren "%_reimgf%" "%_renamed%"

:_main
echo Image name: %_name%
echo Image file: %_reimgf%

if %_osver% LSS 62 goto :_main_opt

set "_tmp=%_reimgd%\tmp"
if not exist "%_tmp%" md "%_tmp%"
dism.exe /capture-image /capturedir:%_letter%:\ /imagefile:"%_reimgf%" /name:"%_name%" /scratchdir:"%_tmp%"
if exist "%_tmp%" rd /S/Q "%_tmp%"
if %ERRORLEVEL% EQU 0 goto :_completed
REM use wimlib on error

:_main_opt
set "_wlib=call "%~dp0utilities\wimlib.bat""
%_wlib% capture %_letter%:\ "%_reimgf%" "%_name%"
if %ERRORLEVEL% EQU 0 goto :_completed

if defined _renamed ren "%_reimgd%\%_renamed%" "%_selectedname%.wim"
echo Error: unable to capture %_letter%
pause & goto :eof

:_completed
echo %~n0 completed
pause