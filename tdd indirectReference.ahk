#Include %A_LineFile%/../indirectReference.ahk

try, testHandler := ComObjActive("{40677553-fdbd-444d-a9dd-6dce43b0cd56}")
catch
{
	Msgbox counldn't connect to test environment
	ExitApp,  -1
}

a  := { f : 1 }
a2 := new indirectReference( a, "__Get" )
if ( a2.f != 1 )
{
	testHandler.setError( "__Get mode failed" )
	ExitApp
}
a3 := new indirectReference( a,  "__Get" )
if a2 != a3
{
	testHandler.setError( "Performance storage failed" )
	ExitApp
}
a := ""
if isObject( a2.base )
{
	testHandler.setError( "Freeing failed" )
	ExitApp
}