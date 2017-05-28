call ver.bat
::%rar% -IBCK x %~p0%curlppx%.tar.gz %~p0
%~pd0%QZ% x "%~pd0%curlppx%.tar.gz" -y -o"%~pd0"
%~pd0%QZ% x "%~pd0%curlppx%.tar" -y -o"%~pd0"
del "%~pd0%curlppx%.tar"
exit