cd /d %~pd0
set rootDir=%cd%
call ver.bat
call build_vs_env.bat %vcvx%
cd /d %~p0
::½âÑ¹ÎÄ¼þ¹þ
rd /s /q %curlppx%
start /wait call ex_curlpp.bat
cd %curlppx%
copy /Y ..\curlpp.VC%vcvx%.vcxproj .\
devenv curlpp.VC%vcvx%.vcxproj /Rebuild "DebugDynamic|Win32"
pause
devenv curlpp.VC%vcvx%.vcxproj /Rebuild "DebugStatic|Win32"
devenv curlpp.VC%vcvx%.vcxproj /Rebuild "ReleaseDynamic|Win32"
devenv curlpp.VC%vcvx%.vcxproj /Rebuild "ReleaseStatic|Win32"
xcopy /E /Y .\include  ..\buid_ok\inc\
::msbuild /rebuild curlpp.VC10.vcxproj
::set ppDir=%cd%
::cd src
::nmake -f curlpp\Makefile.msvc CFG=release
::nmake -f Makefile.msvc CFG=release-dll
::nmake -f Makefile.msvc CFG=debug
::nmake -f Makefile.msvc CFG=debug-dll
pause
cd /d %rootDir%
exit