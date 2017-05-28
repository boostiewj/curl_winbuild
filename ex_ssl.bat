call ver.bat
::%rar% -IBCK x %~p0%sslx%.tar.gz %~p0
%~pd0%QZ% x "%~pd0%sslx%.tar.gz" -y -o"%~pd0"
%~pd0%QZ% x "%~pd0%sslx%.tar" -y -o"%~pd0"
del "%~pd0%sslx%.tar"
exit