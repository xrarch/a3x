struct DeviceNode
	4 Name
	4 Methods
	4 Properties
	4 Alias
endstruct

(* device methods are called like [ ... node -- ... ] *)
struct DeviceMethod
	4 Name
	4 Func
	4 AUC
	4 Board
endstruct

struct DeviceProperty
	4 Name
	4 Value
endstruct

externptr DevTree (* var *)

externptr DevCurrent (* var *)

extern DevTreeWalk { path -- cnode }

extern DeviceParent { -- }

extern DeviceSelectNode { node -- }

extern DeviceSelect { path -- }

extern DeviceNew { -- }

extern DeviceClone { node -- }

extern DeviceCloneWalk { path -- }

extern DSetName { name -- }

extern DAddMethodFull { board method auc name -- }

extern DAddMethod { method name -- }

extern DAddProperty { value name -- }

extern DSetProperty { value name -- }

extern DGetProperty { name -- string }

extern DGetMethod { name -- ptr }

extern DCallMethod { ... name -- out1 out2 out3 ok }

extern DCallMethodPtr { ... ptr -- out1 out2 out3 }

extern DevIteratorInit { -- iter }

extern DevIterate { iterin -- iterout }

extern DeviceExit { -- }

extern DGetName { -- name }

extern DGetMethods { -- methods }

extern DGetProperties { -- properties }

extern DGetCurrent { -- current }