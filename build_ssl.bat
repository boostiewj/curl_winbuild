cd /d %~pd0
set rootDir=%cd%
call ver.bat
call build_vs_env.bat %vcvx%
cd /d %~pd0
::��ѹ�ļ���
if exist %sslx% rd /s /q %sslx%
start /wait call ex_ssl.bat
::����SSL
cd /d %~p0
copy /y nasm.exe %sslx%\nasm.exe
set ZLIB_D=%cd%\%zlibx%
set sslDir=%cd%\%sslx%
set sslInstall=%okInc%\openssl
if not exist %sslInstall% md %sslInstall%
cd /d %sslx%
echo ���ڱ���ssl��debug dll�汾
del /f /q .\ms\*.mak
perl Configure debug-VC-WIN32 zlib no-asm --prefix=%sslInstall% --with-zlib-lib=%ZLIB_D%/zlib1d.lib --with-zlib-include=%ZLIB_D%
call ms\do_ms.bat 
call cscript ..\ssl_config.vbs %sslDir% debug
nmake -f ms\ntdll.mak

echo ���ڱ���ssl��release dll�汾
del /f /q .\ms\*.mak
perl Configure VC-WIN32 zlib no-asm --prefix=%sslInstall% --with-zlib-lib=%ZLIB_D%/zlib1.lib --with-zlib-include=%ZLIB_D%
call ms\do_ms.bat 
call cscript ..\ssl_config.vbs %sslDir% release
nmake -f ms\ntdll.mak

echo ���ڱ���ssl��debug static�汾
del /f /q .\ms\*.mak
perl Configure debug-VC-WIN32 zlib no-asm --prefix=%sslInstall% --with-zlib-lib=%ZLIB_D%/zlibd.lib --with-zlib-include=%ZLIB_D%
call ms\do_ms.bat 
call cscript ..\ssl_config.vbs %sslDir% debug
nmake -f ms\nt.mak

echo ���ڱ���ssl��release static�汾
del /f /q .\ms\*.mak
perl Configure VC-WIN32 zlib no-asm --prefix=%sslInstall% --with-zlib-lib=%ZLIB_D%/zlib.lib --with-zlib-include=%ZLIB_D%
call ms\do_ms.bat 
call cscript ..\ssl_config.vbs %sslDir% release
nmake -f ms\nt.mak


move /Y .\out32\libeay32.lib %okLib%\libeay32.lib
move /Y .\out32\ssleay32.lib %okLib%\ssleay32.lib

move /Y %cd%\out32.dbg\libeay32d.lib %okLib%\libeay32d.lib
move /Y %cd%\out32.dbg\ssleay32d.lib %okLib%\ssleay32d.lib

move /Y %cd%\out32dll\libeay32.lib %okLib%\libeay32_imp.lib
move /Y %cd%\out32dll\ssleay32.lib %okLib%\ssleay32_imp.lib
move /Y %cd%\out32dll\libeay32.dll %okBin%\libeay32.dll
move /Y %cd%\out32dll\ssleay32.dll %okBin%\ssleay32.dll

move /Y %cd%\out32dll.dbg\libeay32d.lib %okLib%\libeay32d_imp.lib
move /Y %cd%\out32dll.dbg\ssleay32d.lib %okLib%\ssleay32d_imp.lib
move /Y %cd%\out32dll.dbg\libeay32d.dll %okBin%\libeay32d.dll
move /Y %cd%\out32dll.dbg\ssleay32d.dll %okBin%\ssleay32d.dll

xcopy /E /Y %cd%\inc32\openssl  %okInc%\openssl\
cd /d %rootDir%
exit
::nmake -f ms\nt.mak
::perl Configure VC-WIN32 zlib no-asm --prefix=%sslInstall%
::--with-zlib-lib=%zlibDir%/zlib1d.lib --with-zlib-include=%zlibDir%
::call ms\do_nasm.bat
::call .\ms\32all_me.bat
::exit
REM echo ���ڱ���ssl��dll debug�汾
REM nmake -f d32dll.mak >nul
REM echo ����ֵ�ǣ�%errorlevel%
REM echo ���ڱ���ssl��dll release�汾
REM nmake -f 32dll.mak  >nul
REM echo ����ֵ�ǣ�%errorlevel%
REM echo ���ڱ���ssl��lib debug�汾
REM nmake -f d32.mak  >nul
REM echo ����ֵ�ǣ�%errorlevel%
REM echo ���ڱ���ssl��dll release�汾
REM nmake -f 32.mak  >nul
REM echo ����ֵ�ǣ�%errorlevel%
