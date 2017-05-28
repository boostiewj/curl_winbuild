cd /d %~pd0
set rootDir=%cd%
call ver.bat
call build_vs_env.bat %vcvx%
cd /d %rootDir%
::解压文件哈
rd /s /q %zlibx%
start /wait call ex_zlib.bat
call ver.bat
::编译zlib
cd .\%zlibx%
set zlibDir=%cd%
copy /y ..\nasm.exe .\
cd contrib\masmx86
call bld_ml32
cd ..\..\
::编译debug版本 多线程运行时DLL版本MDd
echo 正在编译zlib的debug版本
nmake -f win32/Makefile.msc LOC="-DASMV -DASMINF -MDd -Fd"zlibd"" OBJA="inffas32.obj match686.obj" STATICLIB="zlibd.lib" SHAREDLIB="zlib1d.dll" IMPLIB="zlib1d.lib" >nul
echo 返回值是：%errorlevel%
::编译release版本 多线程运行时DLL版本MD
del *.obj *.res
echo 正在编译zlib的release版本
nmake -f win32/Makefile.msc LOC="-DASMV -DASMINF  -MD -Fd"zlib"" OBJA="inffas32.obj match686.obj"  STATICLIB="zlib.lib" SHAREDLIB="zlib1.dll" IMPLIB="zlib1.lib" > nul
echo 返回值是：%errorlevel%
del *.obj *.res
cd /d %rootDir%
::复制
xcopy /R /Y %~p0%zlibx%\*.lib %okLib%\
xcopy /R /Y %~p0%zlibx%\*.dll %okBin%\
xcopy /R /Y %~p0%zlibx%\*.h   %okInc%\zlib\
exit