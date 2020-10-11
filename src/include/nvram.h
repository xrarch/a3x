const NVRAMBase 0xF8001000
const NVRAMSize 65536

const NVRAMVarCount 255

const NVRAMMagic 0x3C001CA7

struct NVRAMHeader
	4 Magic
endstruct

struct NVRAMVariable
	32 Name
	224 Contents
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