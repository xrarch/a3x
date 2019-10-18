struct AIXOHeader
	4 Magic
	4 SymbolTableOffset
	4 SymbolCount
	4 StringTableOffset
	4 StringTableSize
	4 RelocTableOffset
	4 RelocCount
	4 FixupTableOffset
	4 FixupCount
	4 CodeOffset
	4 CodeSize
	1 CodeType
endstruct

struct AIXOSymbol
	4 Name
	4 Value
endstruct

const AIXOMagic 0x4C455830

const AIXOTypeLimn1k 0x1
const AIXOTypePEC 0x2

extern AIXOValidate (* aixo -- good *)

extern AIXOSymbolByName (* name aixo -- value *)

extern AIXOCode (* aixo -- codeoff *)

extern AIXOCodeType (* aixo -- codetype *)