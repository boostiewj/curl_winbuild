On Error Resume Next
Dim g_sslDir: g_sslDir=""
Dim g_bDll: g_bDebug=False
Dim g_bMT: g_bMT=False
'检查是否是xp模式
Function init_file()
    Set objArgs = WScript.Arguments
	If (objArgs.count > 0) then
            g_sslDir=objArgs(0)
            WSH.Echo g_sslDir
    end if
	If (objArgs.count > 1) then
		If objArgs(1) = "debug" then
			g_bDebug=True
			WSH.Echo "debug"
		else
			g_bDebug=False
			WSH.Echo "release"
		end if
	end if
	If (objArgs.count > 2) then
		If objArgs(2) = "mt" then
			g_bMT=True
			WSH.Echo "MT"
		else
			g_bMT=False
			WSH.Echo "MD"
		end if
	end if
end function
Function ReplaceFileTextMuil(sFileName,vString,nSource,nDes)
    Dim FSO: Set FSO = CreateObject("Scripting.FileSystemObject")
	WSH.Echo "xxx:"&sFileName
    Dim fText: Set fText = FSO.OpenTextFile(sFileName)
	WSH.Echo "xxxs:"&sFileName
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
         WSH.Echo "没有修改文件："&sFileName
    end if
end function
Function debug_modify_ntdll_mak()
    Dim sFile1: sFile1 = g_sslDir + "\ms\ntdll.mak"
    Dim arr1:arr1   = array(_
		array(" -WX "," ")_
		,array("O_SSL=     $(LIB_D)\$(SSL).dll","O_SSL=     $(LIB_D)\$(SSL)d.dll")_
		,array("O_CRYPTO=  $(LIB_D)\$(CRYPTO).dll","O_CRYPTO=  $(LIB_D)\$(CRYPTO)d.dll")_
		,array("L_SSL=     $(LIB_D)\$(SSL).lib","L_SSL=     $(LIB_D)\$(SSL)d.lib")_
		,array("L_CRYPTO=  $(LIB_D)\$(CRYPTO).lib","L_CRYPTO=  $(LIB_D)\$(CRYPTO)d.lib")_
        )
    call ReplaceFileTextMuil(sFile1,arr1,0,1)
	Dim sFile2: sFile2 = g_sslDir + "/ms/libeay32.def"
    Dim arr2:arr2   = array(_
		array("LIBRARY         LIBEAY32","LIBRARY         LIBEAY32d")_
        )
    call ReplaceFileTextMuil(sFile2,arr2,0,1)
	
	Dim sFile3: sFile3 = g_sslDir + "/ms/ssleay32.def"
    Dim arr3:arr3   = array(_
		array("LIBRARY         SSLEAY32","LIBRARY         SSLEAY32d")_
        )
    call ReplaceFileTextMuil(sFile3,arr3,0,1)
end function

Function debug_modify_nt_mak()
    Dim sFile1: sFile1 = g_sslDir + "/ms/nt.mak"
    Dim arr1:arr1   = array(_
		array(" -WX "," ")_
		,array("O_SSL=     $(LIB_D)\$(SSL).lib","O_SSL=     $(LIB_D)\$(SSL)d.lib")_
		,array("O_CRYPTO=  $(LIB_D)\$(CRYPTO).lib","O_CRYPTO=  $(LIB_D)\$(CRYPTO)d.lib")_
		,array("L_SSL=     $(LIB_D)\$(SSL).lib","L_SSL=     $(LIB_D)\$(SSL)d.lib")_
		,array("L_CRYPTO=  $(LIB_D)\$(CRYPTO).lib","L_CRYPTO=  $(LIB_D)\$(CRYPTO)d.lib")_
        )
    call ReplaceFileTextMuil(sFile1,arr1,0,1)
end function

Function mt_debug_modify_mak()
    Dim sFile1: sFile1 = g_sslDir + "/ms/ntdll.mak"
	Dim sFile2: sFile2 = g_sslDir + "/ms/nt.mak"
    Dim arr1:arr1   = array(array(" /MDd "," /MTd "))
    call ReplaceFileTextMuil(sFile1,arr1,0,1)
	call ReplaceFileTextMuil(sFile2,arr1,0,1)
end function

Function mt_relese_modify_mak()
    Dim sFile1: sFile1 = g_sslDir + "/ms/ntdll.mak"
	Dim sFile2: sFile2 = g_sslDir + "/ms/nt.mak"
    Dim arr1:arr1   = array(array(" /MD "," /MT "))
    call ReplaceFileTextMuil(sFile1,arr1,0,1)
	call ReplaceFileTextMuil(sFile2,arr1,0,1)
end function
'Function modify_ntdll_mak()
'    Dim sFile1: sFile1 = g_sslDir + "/ms/ntdll.mak"
'    Dim arr1:arr1   = array(_
'		array("L_SSL=     $(LIB_D)\$(SSL).lib","L_SSL=     $(LIB_D)\$(SSL)_imp.lib")_
'		,array("L_CRYPTO=  $(LIB_D)\$(CRYPTO).lib","L_CRYPTO=  $(LIB_D)\$(CRYPTO)_imp.lib")_
'        )
'    call ReplaceFileTextMuil(sFile1,arr1,0,1)
'end function
function main_f()
	if g_bDebug = True then
		call debug_modify_ntdll_mak()
		call debug_modify_nt_mak()
	end if
	if g_bMT = True then 
		if g_bDebug = True then
			call mt_debug_modify_mak()
		else 
			call mt_relese_modify_mak()
		end if 
	end if 
end function
'开始程序
call init_file()
call main_f()
Wscript.Quit
