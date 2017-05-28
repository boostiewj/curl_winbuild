call ver.bat
::%rar% -IBCK x %~p0%curlx%.zip %~p0
%~pd0%QZ% x "%~pd0%curlx%.zip" -y -o"%~pd0"
exit