#SingleInstance,Force
x:=Studio()
project:=x.Current(2)
;menu Unit Test

ObjRegisterActive(testHandler, "{40677553-fdbd-444d-a9dd-6dce43b0cd56}")

if  error := RunTests( project )
{
	Msgbox Tests Failed:`n%error%
	ExitApp
}

/*
For each, includeProject in GetProjectIncluded( project )
{
	if ( "yes" != m("Update " . splitPath( includeProject.file ).Name . " with the new Version of " . splitPath( project.file ).name . " ?", "btn:yn", "ico:?") )
	{
		
	}
}
*/

ExitApp

RunTests( project )
{
	global testHandler
	Loop, Files,% path( project ).dir . "\tdd*.ahk"
	{
		RunWait, "%A_LoopFileLongPath%", "%A_LoopFileDir%", , pid
		if ( testHandler.error )
			return A_loopFileName . " : " . testHandler.error
	}
	return 
}

path( project )
{
	fileName := project.file
	SplitPath, fileName, Filename, Dir, Extension, Name, Drive
	return { file:File, Filename: filename, dir: dir, extension: Extension, Name: Name, Drive: Drive }
}

GetProjectIncluded( project )
{
	global x
	File:=project.File
	SplitPath,File,Filename,Dir
	files:=x.Get("files")
	main:=files.SN( "//*[@filename='" . Filename . "' and @file!='" . File . "']" )
	ret := []
	while(mm:=main.item[a_index-1]){
		ret.Push( xml.ea(ssn(mm,"ancestor::main")) )
	}
	return ret
}

ObjRegisterActive(Object, CLSID, Flags:=0) {
	static cookieJar := {}
	if (!CLSID) {
		if (cookie := cookieJar.Remove(Object)) != ""
			DllCall("oleaut32\RevokeActiveObject", "uint", cookie, "ptr", 0)
		return
	}
	if cookieJar[Object]
		throw Exception("Object is already registered", -1)
	VarSetCapacity(_clsid, 16, 0)
	if (hr := DllCall("ole32\CLSIDFromString", "wstr", CLSID, "ptr", &_clsid)) < 0
		throw Exception("Invalid CLSID", -1, CLSID)
	hr := DllCall("oleaut32\RegisterActiveObject"
	, "ptr", &Object, "ptr", &_clsid, "uint", Flags, "uint*", cookie
	, "uint")
	if hr < 0
		throw Exception(format("Error 0x{:x}", hr), -1)
	cookieJar[Object] := cookie
}

processExist( pid )
{
	process, Exist, % pid
	return ErrorLevel
}

class testHandler
{
	setError( errorString )
	{
		This.error := errorString
	}
	requestOpinion()
	{
		if ( m( "Did the last test run successful?", "btn:yn", "ico:?" ) = "no" )
			This.setError( "User determed failure" )
	}
	reset()
	{
		This.delete( "error" )
	}
}