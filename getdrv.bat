@echo off
setlocal
if not defined _path call "%~dp0defines.bat"

REM get url list
set "_list=%TEMP%\wgetdrv.txt"
cscript //nologo "%~dp0utilities\wudlg.vbs" "%_list%" "Type='Driver'" %~1
if %ERRORLEVEL% NEQ 0 echo There are no applicable drivers & goto :_clean

REM download drivers
call "%~dp0utilities\wget.bat" -i"%_list%" -N -P "%_drv%"
if not exist "%_drv%\*.cab" echo Error: no files in %_drv% & goto :_clean

REM unpack drivers
for /f "tokens=*" %%G in ('dir /b /o:n ^"%_drv%\*.cab^"') do ^
if not exist "%_drv%\%%~nG" md "%_drv%\%%~nG" & expand.exe "%_drv%\%%G" -r -f:* "%_drv%\%%~nG"

REM install drivers
set /p "_stdin=Do you like to install drivers?[y/n]: "
if "%_stdin%"=="y" forfiles /p "%_drv%" /s /m *.inf /c "cmd /c pnputil -i -a @Path"

:_clean
if exist "%_list%" del /q "%_list%"

echo %~n0 completed
pause
