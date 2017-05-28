cd /d %~pd0
set rootDir=%cd%
call ver_mt.bat
call build_vs_env.bat %vcvx%
cd /d %~p0
::½âÑ¹ÎÄ¼þ¹þ
rd /s /q %curlppx%
start /wait call ex_curlpp.bat
call ver_mt.bat
cd %curlppx%
copy /Y ..\curlpp.VC%vcvx%.vcxproj .\
devenv curlpp.VC%vcvx%.vcxproj /Rebuild "DebugDynamicMT|Win32"
devenv curlpp.VC%vcvx%.vcxproj /Rebuild "DebugStaticMT|Win32"
devenv curlpp.VC%vcvx%.vcxproj /Rebuild "ReleaseDynamicMT|Win32"
devenv curlpp.VC%vcvx%.vcxproj /Rebuild "ReleaseStaticMT|Win32"
xcopy /E /Y .\include  %okInc%\
::msbuild /rebuild curlpp.VC10.vcxproj
::set ppDir=%cd%
::cd src
::nmake -f curlpp\Makefile.msvc CFG=release
::nmake -f Makefile.msvc CFG=release-dll
::nmake -f Makefile.msvc CFG=debug
::nmake -f Makefile.msvc CFG=debug-dll
cd /d %rootDir%
exit