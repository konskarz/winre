@echo off
setlocal
if not defined _path call "%~dp0defines.bat"

if exist "%_reimgd%\*.wim" goto :_setname

echo Error: no images found in %_reimgd%
pause & goto :eof

:_setname
echo Available images:
for %%G in ("%_reimgd%\*.wim") do echo %%~nG
set /p "_selectedname=Please enter the image name: "
if "x%_selectedname%"=="x" if exist "%_reimgf%" goto :_getinfo
if not exist "%_reimgd%\%_selectedname%.wim" goto :_setname
set "_reimgf=%_reimgd%\%_selectedname%.wim"

:_getinfo
if %_osver% LSS 62 goto :_getinfo_opt

dism.exe /get-imageinfo /imagefile:"%_reimgf%"
if %ERRORLEVEL% EQU 0 goto :_setindex
REM use wimlib on error

:_getinfo_opt
set "_wlib=call "%~dp0utilities\wimlib.bat""
%_wlib% info "%_reimgf%"
if %ERRORLEVEL% EQU 0 goto :_setindex

echo Error: unable to apply %_wim%
pause & goto :eof

:_setindex
set /p "_index=Please select the index: "
if "x%_index%"=="x" set "_index=1"

REM fsutil fsinfo drives
echo list volume | diskpart

:_setletter
set /p "_letter=Please select the drive letter: "
if not exist %_letter%:\ goto :_setletter

if %_osver% LSS 61 format %_letter%: /fs:ntfs /v:Windows /q & goto :_main

set /p "_stdin=Do you like to format %_letter%?[y/n]: "
if not "%_stdin%"=="y" goto :_main

set "_diskpart=%TEMP%\format.diskpart"
> %_diskpart% echo select volume %_letter%
>> %_diskpart% echo format quick fs=ntfs label=Windows
>> %_diskpart% echo exit
diskpart.exe /s %_diskpart%
del /q "%_diskpart%"

:_main
if defined _wlib %_wlib% apply "%_reimgf%" %_index% %_letter%:\ & goto :_setbcd

set "_tmp=%_reimgd%\tmp"
if not exist "%_tmp%" md "%_tmp%"
dism.exe /apply-image /imagefile:"%_reimgf%" /index:%_index% /applydir:%_letter%:\ /scratchdir:"%_tmp%"
if exist "%_tmp%" rd /S/Q "%_tmp%"
if %ERRORLEVEL% NEQ 0 pause & goto :eof

:_setbcd
if exist "%_letter%:\Boot\BCD" goto :_completed
REM not system partition
set "_windir=%_letter%:\Windows"
if not exist "%_windir%" goto :_completed
REM windows partition
set "_bcdboot=%_windir%\System32\bcdboot.exe"
if not exist "%_bcdboot%" goto :_completed
REM bcdboot available
set /p "_stdin=Do you like to create/update BCD store?[y/n]: "
if not "%_stdin%"=="y" goto :_completed
REM initialize system partition
%_bcdboot% %_windir%

:_completed
echo %~n0 completed
pause