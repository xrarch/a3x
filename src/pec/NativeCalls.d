#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

extern PECAddMethod

table PECNativeCalls
	pointerof DevTreeWalk
	pointerof DeviceParent
	pointerof DeviceSelectNode
	pointerof DeviceSelect
	pointerof DeviceNew
	pointerof DeviceClone
	pointerof DeviceCloneWalk
	pointerof DSetName
	pointerof PECAddMethod
	pointerof DSetProperty
	pointerof DGetProperty
	pointerof DGetMethod
	pointerof DCallMethod
	pointerof DeviceExit
	pointerof DGetName

	pointerof Putc
	pointerof Getc
	pointerof Malloc
	pointerof Calloc
	pointerof Free
	pointerof Puts
	pointerof Gets
	pointerof Printf
endtable

public PECNativeCalls