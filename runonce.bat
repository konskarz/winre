@echo off
setlocal
if not defined _path call "%~dp0defines.bat"

call :_execd "%~dp0%~n0"
if not [%1]==[] call :_execd "%~1\%~n0"

echo.
echo %~n0 completed with status: %ERRORLEVEL%
set /p "_stdin=Do you like to reboot the computer for changes to take effect?[y/n]: "
if not "%_stdin%"=="y" goto :eof
start shutdown.exe -r -t 0
goto :eof

:_execd
if exist "%~1%_osver%" call :_execf "%~1%_osver%"
if exist "%~1" call :_execf "%~1"
goto :eof

:_execf
REM if exist "%~1\*.bat" for /f "tokens=*" %%G in ('dir /b /o:n ^"%~1\*.bat^"') do echo %~1\%%G
REM if exist "%~1\*.reg" for /f "tokens=*" %%G in ('dir /b /o:n ^"%~1\*.reg^"') do echo %~1\%%G
if exist "%~1\*.bat" for /f "tokens=*" %%G in ('dir /b /o:n ^"%~1\*.bat^"') do echo %~1\%%G & call "%~1\%%G"
if exist "%~1\*.reg" for /f "tokens=*" %%G in ('dir /b /o:n ^"%~1\*.reg^"') do echo %~1\%%G & reg.exe import "%~1\%%G"
