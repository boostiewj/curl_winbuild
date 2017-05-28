@echo off
:start
set xpSelect=
set vsVerSel=10.0
cls
:begin
@echo. 
@echo	   Boost1.55编译管理v1.0
@echo. 	  	
@echo 	   1,VS2010		
@echo 	   2,VS2012		3,VS2012+XP
@echo 	   4,VS2013		5,VS2013+XP
@echo 	   6,VS2015		7,VS2015+XP
@echo 	   8,退出
@echo.
@echo.	   提示：编译一次要退出程序，重新再来！
@echo.
@set /p p=请选择:
if %p%==1 goto VS2010
if %p%==2 goto VS2012
if %p%==3 goto VS2012XP
if %p%==4 goto VS2013
if %p%==5 goto VS2013XP
if %p%==6 goto VS2015
if %p%==7 goto VS2015XP
if %p%==8 goto end
goto start
:VS2010
SET vsVerSel=10.0
goto build_start
:VS2012
SET vsVerSel=11.0
goto build_start
:VS2012XP
SET vsVerSel=11.0
set xpSelect=xp
goto build_start
:VS2013
SET vsVerSel=12.0
call 2013_pach.vbs
goto build_start
:VS2013XP
SET vsVerSel=12.0
call 2013_pach.vbs
set xpSelect=xp
goto build_start
:VS2015
SET vsVerSel=14.0
call 2013_pach.vbs
goto build_start
:VS2015XP
SET vsVerSel=14.0
call 2013_pach.vbs
set xpSelect=xp
goto build_start
:build_start
echo 编译开始：>> 时间.txt
time /t >> 时间.txt
@echo 0ff
if not defined INCLUDE set INCLUDE=
if not defined PATH set PATH=
if not defined LIB set LIB=
::if not defined CL set CL=
if defined INCLUDE set INCLUDE_old=%INCLUDE%
if defined PATH set PATH_old=%PATH%
if defined LIB set LIB_old=%LIB%
::if defined CL set CL_old=%CL%
set boostLibDir=
set boostBuildDir=
call build_vs_env.bat %vsVerSel% %xpSelect%
call cscript build_for_xp.vbs %xpSelect%
cd /d "%~dp0"
if exist "./tools/build/v2/engine/bin.ntx86" rd /s/q "./tools/build/v2/engine/bin.ntx86"
if exist "./tools/build/v2/engine/bootstrap" rd /s/q "./tools/build/v2/engine/bootstrap"
@echo on
call bootstrap.bat
if "%boostLibDir%" == "" set boostLibDir=stage
if "%boostBuildDir%" == "" set boostBuildDir=bin.v2
bjam --build-dir=./%boostBuildDir% --toolset=msvc-%vsVerSel% --buildid=%xpSelect% --with-log runtime-link=shared link=shared stage 
::bjam --build-dir=./%boostBuildDir% --toolset=msvc-%vsVerSel% --buildid=%xpSelect% --with-system --with-thread --with-date_time --with-filesystem --with-regex --with-serialization --with-program_options  --with-signals --with-chrono --with-iostreams --with-locale stage 

::bjam --build-dir=./%boostBuildDir% --toolset=msvc-%vsVerSel% --buildid=%xpSelect% --with-system --with-filesystem --with-serialization --with-locale runtime-link=static stage 

::ok
::bjam stage --stagedir=./%boostLibDir% --build-dir=./%boostBuildDir% --toolset=msvc-%vsVerSel% --with-system --with-thread --with-date_time --with-filesystem --with-regex --with-serialization --with-program_options  --with-signals --with-chrono --with-iostreams --with-locale
::bjam stage --stagedir=./%boostLibDir% --build-dir=./%boostBuildDir% --toolset=msvc-%vsVerSel% --with-system --with-filesystem --with-serialization --with-locale runtime-link=static
::ok

::bjam stage --stagedir=./%boostLibDir%  --build-dir=./%boostBuildDir%  --toolset=msvc-%vsVerSel% --with-system runtime-link=shared link=shared
::bjam stage --stagedir=./stage_vc18.0 --build-dir=./bin.v2_vc18.0 --toolset=msvc-12.0 --buildid=99 --with-system
::--toolset=msvc-%vsVerSel%

::bjam --toolset=msvc-12.0 --with-python --build-type=complete %btLibDir%
::bjam --toolset=msvc-12.0 --with-system  runtime-link=static --stagedir=%cd%\%btLibDir% 
::增加gzip支持 bjam --toolset=msvc-10.0 -sZLIB_SOURCE=%cd%/zlib-1.2.8 --with-iostreams stage
::增加bzip支持 bjam --toolset=msvc-10.0 -sBZIP2_SOURCE=%cd%/bzip2-1.0.6 --with-iostreams stage
::gzip,bzip全部支持 bjam --toolset=msvc-10.0 -sBZIP2_SOURCE=%cd%/bzip2-1.0.6 -sZLIB_SOURCE=%cd%/zlib-1.2.8 --with-iostreams stage
::去掉 --without-python
::全部编译 bjam --toolset=msvc-10.0 --with-python --build-type=complete stage
::echo %INCLUDE%
::echo.
::echo %BIN%
::echo.
::echo %PATH%
::echo.
::echo %LIB%
if defined INCLUDE_old set INCLUDE=%INCLUDE_old%
if defined PATH_old set PATH=%PATH_old%
if defined LIB_old set LIB=%LIB_old%
::if defined CL_old set CL=%CL_old%
echo 编译结束：>> 时间.txt
time /t >> 时间.txt
:end
pause
exit