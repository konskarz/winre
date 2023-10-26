@echo off
REM Disable Automatic Updates
net stop wuauserv
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d 1 /f
net start wuauserv
