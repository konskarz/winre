@echo off
REM Disable Error Reporting
net stop ERSvc
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\ERSvc" /v "Start" /t REG_DWORD /d 4 /f
REM net start ERSvc
