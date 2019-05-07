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
endtable

procedure APIDevTree (* -- root dcp *)
	DevCurrent@ DevTree@
end