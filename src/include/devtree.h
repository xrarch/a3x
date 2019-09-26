struct DeviceNode
	4 Name
	4 Methods
	4 Properties
endstruct

(* device methods are called like [ ... node -- ... ] *)
struct DeviceMethod
	4 Name
	4 Func
endstruct

struct DeviceProperty
	4 Name
	4 Value
endstruct

externconst DevTree (* var *)

externconst DevCurrent (* var *)

extern DevTreeWalk (* path -- node or 0 *)

extern DeviceParent (* -- *)

extern DeviceSelectNode (* node -- *)

extern DeviceSelect (* path -- *)

extern DeviceNNew (* -- node *)

extern DeviceNNewOMP (* methodslist propertieslist -- node *)

extern DeviceNew (* -- *)

extern DeviceClone (* node -- *)

extern DeviceCloneWalk (* path -- *)

extern DSetName (* name -- *)

extern DAddMethod (* method name -- *)

extern DAddProperty (* string name -- *)

extern DGetProperty (* name -- string or 0 *)

extern DGetMethod (* name -- ptr or 0 *)

extern DCallMethod (* ... name -- ... ok? *)

extern DeviceExit (* -- *)

extern DGetName (* -- name *)

extern DGetMethods (* -- methods *)

extern DGetProperties (* -- properties *)