#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

table API
	pointerof Putc
	pointerof Getc
	pointerof Gets
	pointerof Puts
	pointerof APIDevTree
	pointerof Malloc
	pointerof Calloc
	pointerof Free

	pointerof DevTreeWalk
	pointerof DeviceParent
	pointerof DeviceSelectNode
	pointerof DeviceSelect
	pointerof DGetProperty
	pointerof DGetMethod
	pointerof DCallMethod
	pointerof DeviceExit
	pointerof DSetProperty
endtable
public API

procedure private APIDevTree (* -- root dcp *)
	DevCurrent@ DevTree@
end