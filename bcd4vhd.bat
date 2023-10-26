@echo off
setlocal
if not defined _path call "%~dp0defines.bat"
set "_desc=Native Boot"

REM find guid from description
for /f "tokens=1* delims= " %%i in ('bcdedit /v') do (
	if "%%i"=="Bezeichner" set "_guid=%%j"
	if "%%i"=="description" if "%%j"=="%_desc%" goto :_delete
)

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
set /p "_stdin=Do you like to add %_vhd% to BCD store?[y/n]: "
if not "%_stdin%"=="y" goto :_getinfo

for /f "tokens=2 delims={}" %%G in ('bcdedit /copy {current} /d "%_desc%"') do set "_guid={%%G}"
for %%G in ("%_vhd%") do set "_pnx=%%~pnxG"
bcdedit /set %_guid% device vhd=[locate]%_pnx%
bcdedit /set %_guid% osdevice vhd=[locate]%_pnx%
bcdedit /set %_guid% detecthal on
REM bcdedit /default %_guid%
goto :_getinfo

:_delete
set /p "_stdin=Do you like to delete %_desc% from BCD store?[y/n]: "
if not "%_stdin%"=="y" goto :_getinfo

bcdedit /delete %_guid% /cleanup

:_getinfo
bcdedit /v

echo %~n0 completed
pause