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

set "_letter=V"
if exist "%_vhd%" goto :_format
if not exist "%_boot%" md "%_boot%"

set "_diskpart=%TEMP%\create.diskpart"
> %_diskpart% echo create vdisk file=%_vhd% maximum=25600 type=expandable
>> %_diskpart% echo select vdisk file=%_vhd%
>> %_diskpart% echo attach vdisk
>> %_diskpart% echo create partition primary
>> %_diskpart% echo detach vdisk
>> %_diskpart% echo exit
diskpart.exe /s %_diskpart%
del /q "%_diskpart%"

:_format
set "_diskpart=%TEMP%\format.diskpart"
> %_diskpart% echo select vdisk file=%_vhd%
>> %_diskpart% echo attach vdisk
>> %_diskpart% echo select partition 1
>> %_diskpart% echo assign letter=%_letter%
>> %_diskpart% echo format quick fs=ntfs label=Windows
>> %_diskpart% echo exit
diskpart.exe /s %_diskpart%
del /q "%_diskpart%"

if defined _wlib %_wlib% apply "%_reimgf%" %_index% %_letter%:\ & goto :_detach

dism.exe /apply-image /imagefile:"%_reimgf%" /index:%_index% /applydir:%_letter%:\

:_detach
set "_diskpart=%TEMP%\detach.diskpart"
> %_diskpart% echo select vdisk file=%_vhd%
>> %_diskpart% echo detach vdisk
>> %_diskpart% echo exit
diskpart.exe /s %_diskpart%
del /q "%_diskpart%"

echo %~n0 completed
pause