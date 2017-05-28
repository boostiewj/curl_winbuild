cd /d %~pd0
set rootDir=%cd%
call ver.bat
call build_vs_env.bat %vcvx%
::½âÑ¹ÎÄ¼þ¹þ
if exist %curlx% rd /s /q %curlx%
start /wait call ex_curl.bat
::start /wait call copy_zlib_ssl.bat
set ZLIB_PATH=%okInc%\zlib
set OPENSSL_PATH=%rootDir%\%sslx%

::debug-ssl-zlib
cd %curlx%/lib
copy /Y %okLib%\libeay32d.lib %OPENSSL_PATH%\out32\libeay32.lib
copy /Y %okLib%\ssleay32d.lib %OPENSSL_PATH%\out32\ssleay32.lib
copy /Y %okLib%\zlibd.lib        %ZLIB_PATH%\zlib.lib
nmake /f Makefile.vc14 CFG=debug-ssl-zlib

copy /y debug-ssl-zlib\libcurld.lib %okLib%\
del /Q %ZLIB_PATH%\*.lib
cd /d %rootDir%
::release-ssl-zlib
cd %curlx%/lib
copy /Y %okLib%\libeay32.lib %OPENSSL_PATH%\out32\libeay32.lib
copy /Y %okLib%\ssleay32.lib %OPENSSL_PATH%\out32\ssleay32.lib
copy /Y %okLib%\zlib.lib        %ZLIB_PATH%\zlib.lib
nmake /f Makefile.vc14 CFG=release-ssl-zlib
copy /y release-ssl-zlib\libcurl.lib %okLib%\
del /Q %ZLIB_PATH%\*.lib

::debug-dll-ssl-dll-zlib-dll
cd %curlx%/lib
copy /Y %okLib%\libeay32d_imp.lib %OPENSSL_PATH%\out32dll\libeay32.lib
copy /Y %okLib%\ssleay32d_imp.lib %OPENSSL_PATH%\out32dll\ssleay32.lib
copy /Y %okLib%\zlib1d.lib        %ZLIB_PATH%\zdll.lib
nmake /f Makefile.vc14 CFG=debug-dll-ssl-dll-zlib-dll
copy /y debug-dll-ssl-dll-zlib-dll\libcurld.dll %okBin%\libcurld.dll
copy /y debug-dll-ssl-dll-zlib-dll\libcurld_imp.lib %okLib%\libcurld_imp.lib
del /Q %ZLIB_PATH%\*.lib
cd /d %rootDir%
::release-dll-ssl-dll-zlib-dll
cd %curlx%/lib
copy /Y %okLib%\libeay32_imp.lib %OPENSSL_PATH%\out32dll\libeay32.lib
copy /Y %okLib%\ssleay32_imp.lib %OPENSSL_PATH%\out32dll\ssleay32.lib
copy /Y %okLib%\zlib1.lib        %ZLIB_PATH%\zdll.lib
nmake /f Makefile.vc14 CFG=release-dll-ssl-dll-zlib-dll
copy /y release-dll-ssl-dll-zlib-dll\libcurl.dll %okBin%\
copy /y release-dll-ssl-dll-zlib-dll\libcurl_imp.lib %okLib%\
del /Q %ZLIB_PATH%\*.lib
cd /d %rootDir%


cd /d %rootDir%
xcopy /E /Y %rootDir%\%curlx%\include\curl  %okInc%\curl\
exit
