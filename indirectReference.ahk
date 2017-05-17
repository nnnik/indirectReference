class indirectReference
{
	
	static relationStorage    := {}
	static performanceStorage := {}
	static accessStorage      := {}
	static modeStorage        := {}
	static baseModes          := { __Call:indirectReference.Call, __Set:indirectReference.Set, __Get:indirectReference.Get, __New:indirectReference.New, __Delete:indirectReference.Delete, _NewEnum:"" }
	
	__New( obj, modeOrModeStr := "__Call" )
	{
		if !isObject( obj )
			return
		if isObject( modeOrModeStr )
		{
			str := ""
			For modeName, val in modeOrModeStr
				str .= modeName . "|"
			modeOrModeStr := subStr( str, 1, -1 )
		}
		if !indirectReference.performanceStorage.hasKey( &obj )
		{
			indirectReference.performanceStorage[ &obj ] := []
			indirectReference.accessStorage[ &obj ] := []
		}
		if ( !indirectReference.performanceStorage[ &obj ].hasKey( modeOrModeStr ) | deleteMode := inStr( modeOrModeStr, "__Delete" ) )
		{
			if !indirectReference.modeStorage.hasKey( modeOrModeStr )
			{
				newMode := {}
				modes := strSplit( modeOrModeStr, "|" )
				for each, mode in modes
					newMode[ mode ] := This.baseModes[ mode ]
				indirectReference.modeStorage[ modeOrModeStr ] := newMode
			}
			newReference := { base: indirectReference.modeStorage[ modeOrModeStr ] }
			This.accessStorage[ &obj ].Push( newReference )
			This.relationStorage[ &neReference ] := &obj
			if !deleteMode
				indirectReference.performanceStorage[ &obj, modeOrModeStr ] := newReference
		}
		return indirectReferences.performanceStorage[ &obj, modeOrModeStr ]
	}
	
	DeleteObject( __Delete := "" )
	{
		for each, reference in indirectReference.acessStorage[ &This ]
		{
			indirectReference.relationStorage.delete( &reference )
			reference.base := ""
		}
		indirectReference.accessStorage.Delete( &This )
		indirectReference.performanceStorage.Delete( &This )
		if isFunc( __Delete )
			return __Delete.Call( This )
	}
	
	Call( functionName = "", parameters* )
	{
		if !indirectReference.connectBase.hasKey( functionName )
			return ( new directReference( This ) )[ functionName ]( parameters* )
	}
	
	Set( keyAndValue* )
	{
		Value := keyAndValue.Pop()
		return ( new directReference( This ) )[ keyAndValue* ] := Value 
	}
	
	Get( key* )
	{
		return ( new directReference( This ) )[ key* ]
	}
	
	New( parameters* )
	{
		newIndirectReference := This.base
		This.base := ""
		return new ( new directReference( newIndirectReference ) )( parameter* )
	}
	
	Delete()
	{
		return ( new directReference( This ) ).__Delete()
	}
	
}

class directReference
{
	__New( reference )
	{
		if indirectReference.relationStorage.hasKey( &reference )
			return Object( indirectReference.relationStorage[ &reference ] )
	}
}