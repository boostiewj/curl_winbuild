On Error Resume Next
Dim g_bXP: g_bXP=False
'检查是否是xp模式
Function ck_xp()
    Set objArgs = WScript.Arguments
    If (objArgs.count > 0) then
        if objArgs(0) = "xp" then
            g_bXP=True
            WSH.Echo "xp模式"
        else
            g_bXP=False
            WSH.Echo "非xp模式"
        end if
    end if 
end function
Function ReplaceFileTextMuil(sFileName,vString,nSource,nDes)
    Dim FSO: Set FSO = CreateObject("Scripting.FileSystemObject")
    Dim fText: Set fText = FSO.OpenTextFile(sFileName)
    Dim strContent: strContent = fText.Readall
    fText.Close
    Dim strContentOld: strContentOld = strContent
    For i=0 To UBound(vString)-LBound(vString)
        strContent = Replace(strContent,vString(i)(nSource),vString(i)(nDes))
    Next
    if StrComp(strContent,strContentOld) <> 0 then
        WSH.Echo "修改了文件"&sFileName
        Dim fText2: Set fText2 = FSO.CreateTextFile(sFileName)
        fText2.Write (strContent)
        fText2.close
    else
         'WSH.Echo "没有修改文件："&sFileName
    end if
end function
'配置boost编译文件
Function ck_boost_build()
    Dim nSource: nSource = 1
    Dim nDes: nDes = 0
    If g_bXP = True then
        WSH.Echo "xp模式"
        nSource = 0
        nDes = 1
    Else
        WSH.Echo "非xp模式"
    End If

    Dim strBuildFileName: strBuildFileName = "./tools/build/v2/engine/build.jam"
    '_USING_V110_SDK71_ 好像不起作用阿
    Dim arrBuildAll:arrBuildAll   = array(_
        array(  "toolset vc11 cl : /Fe /Fe /Fd /Fo : -D",_
            "toolset vc11 cl : /Fe /Fe /Fd /D _USING_V110_SDK71_ /Fo : -D")_
        ,array( "toolset vc12 cl : /Fe /Fe /Fd /Fo : -D",_
             "toolset vc12 cl : /Fe /Fe /Fd /D _USING_V110_SDK71_ /D WANGJI /Fo : -D")_
        )
    call ReplaceFileTextMuil(strBuildFileName,arrBuildAll,nSource,nDes)
    Dim strBatFileName: strBatFileName = "./tools/build/v2/engine/build.bat"
    Dim arrBatAll:arrBatAll   = array(_
    array(  "BOOST_JAM_CC=cl /nologo",_
            "BOOST_JAM_CC=cl /D _USING_V110_SDK71_ /nologo")_
    )
    call ReplaceFileTextMuil(strBatFileName,arrBatAll,nSource,nDes)

    Dim strLinkFileName: strLinkFileName = "./tools/build/v2/tools/msvc.jam"
    '_USING_V110_SDK71_ 这个起作用！
    Dim arrLinkAll:arrLinkAll   = array(_
    array(  "$(setup-$(c))$(compiler) /Zm800 -nologo ;",_
            "$(setup-$(c))$(compiler) /Zm800 /D _USING_V110_SDK71_ -nologo ;")_
    ,array(  "console : /subsystem:console ;",_
            "console : /subsystem:console,""5.01"" ;")_
    ,array( "gui : /subsystem:windows ;",_
            "gui : /subsystem:windows,""5.01"" ;")_
    )
   call ReplaceFileTextMuil(strLinkFileName,arrLinkAll,nSource,nDes)
   Dim strPyFileName: strPyFileName = "./tools/build/v2/tools/msvc.py"
   Dim arrPyAll:arrPyAll   = array(_
    array(  "$(setup-$(c))$(compiler) /Zm800 -nologo ;",_
            "$(setup-$(c))$(compiler) /Zm800 /D _USING_V110_SDK71_ -nologo ;")_
    ,array(  "['/subsystem:console']",_
            "['/subsystem:console,""5.01""']")_
    ,array( "['/subsystem:windows']",_
            "['/subsystem:windows,""5.01""']")_
    )
   call ReplaceFileTextMuil(strPyFileName,arrPyAll,nSource,nDes)
end function
'替换文件文本
Function ReplaceFileText(sFileName,sSource,sDes)
    Dim FSO: Set FSO = CreateObject("Scripting.FileSystemObject")
    Dim fText: Set fText = FSO.OpenTextFile(sFileName)
    Dim strContent: strContent = fText.Readall
    fText.Close
    Dim strContentOld: strContentOld = strContent
    strContent = Replace(strContent,sSource,sDes)
    if StrComp(strContent,strContentOld) <> 0 then
        WSH.Echo "修改了文件"&sFileName
        Dim fText2: Set fText2 = FSO.CreateTextFile(sFileName)
        fText2.Write (strContent)
        fText2.close
    else
         'WSH.Echo "没有修改文件："&sFileName
    end if
end Function
'修复boost源码bug
Function ck_boost_code()
     Dim strFileName: strFileName = "./boost/archive/iterators/transform_width.hpp"
     Dim sSourceText: sSourceText="#include <xutility>"&Chr(13)&Chr(10)&Chr(13)&Chr(10)&"//"
     Dim sDesText: sDesText="#include <xutility>"&Chr(13)&Chr(10)&"#if defined(_MSC_VER) && (_MSC_VER >= 1800)"&Chr(13)&Chr(10)&"#include <algorithm>"&Chr(13)&Chr(10)&"#endif"&Chr(13)&Chr(10)&Chr(13)&Chr(10)&"//"
     Call ReplaceFileText(strFileName,sSourceText,sDesText)
end Function
'获取bat位置
Function getVC_BatPach(vsVer,bIs32)
    Dim sReg: sReg = "HKEY_CURRENT_USER\Software\Microsoft\VisualStudio\"&vsVer&"_Config\InstallDir"
    set WshShell = Wscript.CreateObject("Wscript.Shell")
    Dim sPath: sPath = WshShell.RegRead(sReg)
	if Err.Number>0 then
		Exit function
	end if
    if bIs32 = True then
        sPath = sPath&"../../VC/bin/vcvars32.bat"
    else
         sPath = sPath&"../../VC/bin/amd64/vcvars64.bat"
    end if
    'WSH.Echo sPath
    getVC_BatPach = sPath
end function
'修改bat文件适合xp
Function ck_vs_bat(vsVer,bIs32)
     Dim sSourceText: sSourceText=":end"&Chr(13)&Chr(10)&Chr(13)&Chr(10)
     Dim sDesText: sDesText=":end"&Chr(13)&Chr(10)&_
        "set setXP_INC=0"&Chr(13)&Chr(10)&_
        "if defined isXP_build if %isXP_build% == 1 set setXP_INC=1"&Chr(13)&Chr(10)&_
        "if %setXP_INC% == 1 set INCLUDE=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Include;%INCLUDE%"&Chr(13)&Chr(10)&_
        "if %setXP_INC% == 1 set PATH=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Bin;%PATH%"&Chr(13)&Chr(10)
     if bIs32 = True then
        sDesText = sDesText&"if %setXP_INC% == 1 set LIB=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Lib;%LIB%"&Chr(13)&Chr(10)&Chr(13)&Chr(10)
     else
        sDesText = sDesText&"if %setXP_INC% == 1 set LIB=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Lib\x64;%LIB%"&Chr(13)&Chr(10)&Chr(13)&Chr(10)
     end if
     Dim strFileName: strFileName = getVC_BatPach(vsVer,bIs32)
     Call ReplaceFileText(strFileName,sSourceText,sDesText)
     Exit Function
end Function
'修改boost适合xp自动链接
Function ck_boost_auto_link()
	 Dim arrAll:arrAll   = array(_
        array(Chr(13)&Chr(10)&Chr(13)&Chr(10)&"#ifdef BOOST_AUTO_LINK_TAGGED",_
        Chr(13)&Chr(10)&Chr(13)&Chr(10)&_
		"#if ( _MSC_VER >= 1700) && defined(_USING_V110_SDK71_) && defined(SUPPORT_XP_APP)"&Chr(13)&Chr(10)&_
		"#	define BT_XP_OPT ""-xp"""&Chr(13)&Chr(10)&_
		"#else"&Chr(13)&Chr(10)&_
		"#	define BT_XP_OPT """""&Chr(13)&Chr(10)&_
		"#endif"&Chr(13)&Chr(10)&_
		"#ifdef BOOST_AUTO_LINK_TAGGED")_
        ,array("BOOST_LIB_RT_OPT "".lib""",_
             "BOOST_LIB_RT_OPT BT_XP_OPT "".lib""")_
		,array("BOOST_STRINGIZE(BOOST_LIB_NAME) "".lib""",_
             "BOOST_STRINGIZE(BOOST_LIB_NAME) BT_XP_OPT "".lib""")_
		,array("BOOST_LIB_VERSION "".lib""",_
             "BOOST_LIB_VERSION BT_XP_OPT "".lib""")_
        )
     Dim strFileName: strFileName = "./boost/config/auto_link.hpp"
	 Dim nSource: nSource=0
	 Dim nDes: nDes=1
     Call ReplaceFileTextMuil(strFileName,arrAll,nSource,nDes)
     Exit Function
end Function
'开始程序
call ck_xp()            '检查参数
call ck_boost_build()   '配置boost编译文件
call ck_boost_auto_link()
call ck_boost_code()    '修复boost在2013下bug
call ck_vs_bat("11.0",True)     '32bat
call ck_vs_bat("11.0",False)    '64bat
call ck_vs_bat("12.0",True)
call ck_vs_bat("12.0",False)
Wscript.Quit
