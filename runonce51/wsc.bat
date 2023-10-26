@echo off
REM Disable Security Center
net stop wuauserv
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\wscsvc" /v "Start" /t REG_DWORD /d 4 /f
REM net start wuauserv
