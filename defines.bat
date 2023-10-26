@echo off
setlocal
set "_pathname=Depot"
if exist "%~d0\%_pathname%" set "_path=%~d0\%_pathname%" & goto :_exist
for %%G in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do ^
if exist "%%G:\%_pathname%" set "_path=%%G:\%_pathname%" & goto :_exist
:_set
set /p "_path=Please select a folder: "
if not exist "%_path%" goto :_set
:_exist
endlocal & set "_path=%_path%"

for /f "tokens=2 delims=[]" %%G in ('ver') do ^
for /f "tokens=2,3 delims=. " %%H in ('echo %%G') do set "_osver=%%H%%I"
REM 51=Windows XP
REM 52=Windows 2003
REM 60=Windows Vista
REM 61=Windows 7
REM 62=Windows 8
REM 100=Windows 10

set "_tools=%_path%\Tools"
set "_reimgd=%_path%\ReImg"
set "_reimgf=%_reimgd%\install.wim"
set "_boot=%_path%\Boot"
set "_vhd=%_boot%\install.vhd"
set "_drv=%_path%\Audit\Drivers"
set "_upd=%_path%\Audit\Updates"
