cd /d %~pd0
set rootDir=%cd%
call ver.bat
call build_vs_env.bat %vcvx%
cd /d %rootDir%
::��ѹ�ļ���
rd /s /q %zlibx%
start /wait call ex_zlib.bat
call ver.bat
::����zlib
cd .\%zlibx%
set zlibDir=%cd%
copy /y ..\nasm.exe .\
cd contrib\masmx86
call bld_ml32
cd ..\..\
::����debug�汾 ���߳�����ʱDLL�汾MDd
echo ���ڱ���zlib��debug�汾
nmake -f win32/Makefile.msc LOC="-DASMV -DASMINF -MDd -Fd"zlibd"" OBJA="inffas32.obj match686.obj" STATICLIB="zlibd.lib" SHAREDLIB="zlib1d.dll" IMPLIB="zlib1d.lib" >nul
echo ����ֵ�ǣ�%errorlevel%
::����release�汾 ���߳�����ʱDLL�汾MD
del *.obj *.res
echo ���ڱ���zlib��release�汾
nmake -f win32/Makefile.msc LOC="-DASMV -DASMINF  -MD -Fd"zlib"" OBJA="inffas32.obj match686.obj"  STATICLIB="zlib.lib" SHAREDLIB="zlib1.dll" IMPLIB="zlib1.lib" > nul
echo ����ֵ�ǣ�%errorlevel%
del *.obj *.res
cd /d %rootDir%
::����
xcopy /R /Y %~p0%zlibx%\*.lib %okLib%\
xcopy /R /Y %~p0%zlibx%\*.dll %okBin%\
xcopy /R /Y %~p0%zlibx%\*.h   %okInc%\zlib\
exit