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
set "_what=image"
if %_osver% LSS 62 set "_what=wim"
dism.exe /get-%_what%info /%_what%file:"%_reimgf%"
if %ERRORLEVEL% NEQ 0 pause & goto :eof

:_setindex
set /p "_index=Please select the index: "
if "x%_index%"=="x" set "_index=1"

set "_tmp=%_reimgd%\tmp"
if not exist "%_tmp%" md "%_tmp%"
dism.exe /mount-%_what% /%_what%file:"%_reimgf%" /index:%_index% /mountdir:"%_tmp%"
if %ERRORLEVEL% NEQ 0 goto :_discard

echo Image file: %_reimgf%
echo Image index: %_index%
echo Mounted at: %_tmp%

if not exist "%_drv%" goto :_updates

set /p "_stdin=Do you like to add drivers from %_drv%?[y/n]: "
if "%_stdin%"=="y" dism.exe /image:"%_tmp%" /add-driver /driver:"%_drv%" /recurse

:_updates
if not exist "%_upd%" goto :_unmount

set /p "_stdin=Do you like to add updates from %_upd%?[y/n]: "
if "%_stdin%"=="y" for /f "tokens=*" %%G in ('dir /b /s /a:d "%_upd%"') do ^
dism.exe /image:"%_tmp%" /add-package /packagepath:"%%G"

:_unmount
set /p "_stdin=Do you like to save changes?[y/n]: "
if not "%_stdin%"=="y" goto :_discard
dism.exe /unmount-%_what% /mountdir:%_tmp% /commit
goto :_clean

:_discard
dism.exe /unmount-%_what% /mountdir:%_tmp% /discard

:_clean
if exist "%_tmp%" rd /S/Q "%_tmp%"

echo %~n0 completed
pause