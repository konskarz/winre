@echo off
setlocal
del /F /S /Q %TEMP%
for /F "tokens=*" %%G in ('dir /b ^"%USERPROFILE%\*.log^"') do del "%USERPROFILE%\%%G"
if exist %SYSTEMDRIVE%\Config.Msi rmdir /S /Q %SYSTEMDRIVE%\Config.Msi
