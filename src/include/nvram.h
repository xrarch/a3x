const NVRAMBase 0xF8001000
const NVRAMSize 65536

const NVRAMVarCount 255

const NVRAMMagic 0x0C001CA7

struct NVRAMHeader
	4 Magic
endstruct

struct NVRAMVariable
	16 Name
	240 Contents
endstruct

extern NVRAMCheck (* -- ok? *)

extern NVRAMFormat (* -- *)

extern NVRAMOffset (* loc -- nvaddr *)

extern NVRAMFindFree (* -- free or 0 *)

extern NVRAMDeleteVar (* name -- *)

extern NVRAMSetVar (* str name -- *)

extern NVRAMSetVarNum (* num name -- *)

extern NVRAMGetVar (* name -- ptr or 0 *)

extern NVRAMGetVarNum (* var -- n *)