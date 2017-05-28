@echo on
set vsVerSel=10.0
set boostLibDir=
set isXP_build=0
set VCInstallDir=
if "%2" == "xp" set isXP_build=1
if "%1" == "" goto vs_st1
if "%1" == "10.0" goto vs_st0
if "%1" == "11.0" goto vs_st0
if "%1" == "12.0" goto vs_st0
if "%1" == "14.0" goto vs_st0
echo ”error vc version“&goto error
:vs_st0
set vsVerSel=%1
:vs_st1
set boostLibDir=stage_vc%vsVerSel%
set boostBuildDir=bin.v2_vc%vsVerSel%
::set "boostLibDir=%boostLibDir:.=_%"
if %isXP_build% == 1 set boostLibDir=%boostLibDir%_xp
if %isXP_build% == 1 set boostBuildDir=%boostBuildDir%_xp
::set cur_dir_en=%cd%
::echo %vsVerSel%
::SETLOCAL ENABLEDELAYEDEXPANSION
for /f "delims=" %%i in ('REG.EXE QUERY "HKEY_CURRENT_USER\Software\Microsoft\VisualStudio\%vsVerSel%_Config" /V "InstallDir"') do set VCInstallDir="%%i"
::@if %errorlevel% NEQ 0 if %errorlevel% NEQ 9009 ( echo "错误：找不到编译器安装"&goto error )
Rem 去掉前后双引号
set "VCInstallDir=%VCInstallDir:~1,-1%"
Rem 删除REG_SZ
set "VCInstallDir=%VCInstallDir:REG_SZ=%"
Rem 删除InstallDir
set "VCInstallDir=%VCInstallDir:InstallDir=%"
Rem 删除左边空格
for /f "tokens=*" %%i in ("%VCInstallDir%") do set VCInstallDir=%%i
::下面方法XP不行
:::intercept_left
::if "%VCInstallDir:~0,1%"==" " set "VCInstallDir=%VCInstallDir:~1%"&set VCInstallDir=%VCInstallDir% &goto intercept_left
echo %VCInstallDir%
IF NOT EXIST "%VCInstallDir%" ( echo ”查找VC错误“&goto error )
call "%VCInstallDir%..\..\VC\vcvarsall.bat" x86
if %isXP_build% == 1 echo build_xp
if %isXP_build% == 1 set INCLUDE=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Include;%INCLUDE%
if %isXP_build% == 1 set PATH=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Bin;%PATH%
if %isXP_build% == 1 set LIB=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Lib;%LIB%
::if %isXP_build% == 1 set CL=/D_USING_V110_SDK71_;%CL%

goto ok
:error
pause
::exit
:ok
cd /d "%~dp0"
::cd /d %cur_dir_en%
