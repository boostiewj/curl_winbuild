call ver.bat
::%rar% -IBCK x %~pd0%zlibZIP%.zip %~pd0
%~pd0%QZ% x "%~pd0%zlibZIP%.zip" -y -o"%~pd0"
exit