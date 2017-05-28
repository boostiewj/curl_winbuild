set zlibZIP=zlib128
set vcvx=14.0
rem 解压后的目录
set zlibx=zlib-1.2.8
set sslx=openssl-1.0.2k
set curlx=curl-7.53.1
set curlppx=curlpp-0.8.1
set rar="C:\Program Files\WinRAR\WinRAR.exe"
set QZ=
rem if %processor_architecture%==x86 (set QZ=7z32.exe) else (set QZ=7z64.exe)
if "%PROCESSOR_IDENTIFIER:~5,2%"=="64" (set QZ=7z64.exe) else (set QZ=7z32.exe)
set okBin=%~p0buid_ok\bin
set okInc=%~p0buid_ok\inc
set okLib=%~p0buid_ok\lib
if not exist %okBin% md %okBin%
if not exist %okInc% md %okInc%
if not exist %okLib% md %okLib%