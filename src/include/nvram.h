const NVRAMBase 0xF8001000
const NVRAMSize 4096

const NVRAMVarCount 31

const NVRAMMagic 0x5C001CA7

struct NVRAMHeader
	4 Magic
	60 Padding
	64 PermanentlyReserved // xremu stores some RTC information here...
endstruct

struct NVRAMVariable
	32 Name
	96 Contents
endstruct

extern NVRAMCheck { -- ok }

extern NVRAMFormat { -- }

extern NVRAMOffset { loc -- nvaddr }

extern NVRAMFindFree { -- free }

extern NVRAMDeleteVar { name -- }

extern NVRAMSetVar { str name -- }

extern NVRAMSetVarNum { num name -- }

extern NVRAMGetVar { name -- ptr }

extern NVRAMGetVarNum { var -- n }

extern NVRAMDefaultGetVar { default name -- ptr }

extern NVRAMDefaultGetVarNum { default var -- n }