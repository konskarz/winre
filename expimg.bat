@echo off
setlocal
if not defined _path call "%~dp0defines.bat"

REM find source
set "_srcpath=sources\install"
for %%G in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
	if exist "%%G:\%_srcpath%.wim" set "_src=%%G:\%_srcpath%.wim" & goto :_getinfo
	if exist "%%G:\%_srcpath%.esd" set "_src=%%G:\%_srcpath%.esd" & goto :_getinfo
)
:_setsource
set /p "_src=Please select source image: "
if not exist "%_src%" goto :_setsource

:_getinfo
if %_osver% LSS 62 goto :_getinfo_opt

dism.exe /get-wiminfo /wimfile:"%_src%"
if %ERRORLEVEL% EQU 0 goto :_setindex
REM use wimlib on error

:_getinfo_opt
set "_wlib=call "%~dp0utilities\wimlib.bat""
%_wlib% info "%_src%"
if %ERRORLEVEL% EQU 0 goto :_setindex

echo Error: unable to export %_src%
pause & goto :eof

:_setindex
set /p "_index=Please select the index: "
if "x%_index%"=="x" set "_index=1"

if not exist "%_reimgd%\*.wim" goto :_setname

echo Existing images:
for %%G in ("%_reimgd%\*.wim") do echo %%~nG

:_setname
set /p "_selectedname=Please enter the image name: "
if "x%_selectedname%"=="x" if not exist "%_reimgf%" goto :_main
if "x%_selectedname%"=="x" goto :_setname

set "_reimgf=%_reimgd%\%_selectedname%.wim"
if not exist "%_reimgf%" goto :_main

REM rename existing
for %%G in ("%_reimgf%") do set "_fdt=%%~tG"
set "_fdt=%_fdt:~6,4%%_fdt:~3,2%%_fdt:~0,2%%_fdt:~11,2%%_fdt:~14,2%"
set "_renamed=%_selectedname%%_fdt: =0%.wim"
echo Rename: %_reimgf% to %_renamed%
ren "%_reimgf%" "%_renamed%"

:_main
echo Source image: %_src%
echo Target image: %_reimgf%

if not exist "%_reimgd%" md "%_reimgd%"
if defined _wlib goto :_main_opt

dism.exe /export-image /sourceimagefile:"%_src%" /sourceindex:%_index% /destinationimagefile:"%_reimgf%" /compress=max
if %ERRORLEVEL% EQU 0 dism.exe /get-imageinfo /imagefile:"%_reimgf%" & goto :_completed
REM use wimlib on error

:_main_opt
%_wlib% export "%_src%" %_index% "%_reimgf%" --compress=LZX
%_wlib% info "%_reimgf%"

:_completed
echo %~n0 completed
pause