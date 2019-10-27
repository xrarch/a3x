#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

externconst PECNativeCalls

extern PECInterpret

var PECCurrent -1
public PECCurrent

var PECCurrentBoard -1
public PECCurrentBoard

var PECStack 0
public PECStack

var PECReturnStack 0
public PECReturnStack

var PECBase 0
public PECBase

const NativeCallCount 23

table PECErrors
	"Illegal bytecode"
	"ok"
	"Invalid nativecall"
	"Invalid PEC ROM"
	"Missing PECInit symbol"
endtable
public PECErrors

procedure PECInit { -- }
	1024 Malloc PECStack!
	1024 Malloc PECReturnStack!
end

procedure PECNativeCall { num -- ok }
	if (num@ NativeCallCount >=)
		0 ok!
		return
	end

	[num@]PECNativeCalls@ Call
	1 ok!
end

procedure PECEvaluate { slotspace pec -- ok }
	1 ok!

	if (pec@ AIXOValidate ~~)
		3 ok!
		return
	end

	if (pec@ AIXOCodeType AIXOTypePEC ~=)
		3 ok!
		return
	end

	auto imgsize
	pec@ AIXOSize imgsize!

	auto newloc
	imgsize@ Malloc newloc!

	newloc@ pec@ imgsize@ memcpy

	auto pip
	"PECInit" newloc@ AIXOSymbolByName pip!

	if (pip@ -1 ==)
		4 ok!
		return
	end

	slotspace@ pip@ newloc@ AIXOCode + newloc@ PECEvaluateFunc ok!
end

procedure PECAddMethod { ptr name -- }
	PECCurrentBoard@ ptr@ PECCurrent@ name@ DAddMethodFull
end

procedure PECEvaluateFunc { slotspace func pec -- ok }
	pec@ PECCurrent!

	slotspace@ PECCurrentBoard!

	pec@ AIXOCode PECBase!

	slotspace@ func@ PECBase@ PECInterpret ok!
end