struct BootRecord
	4 Magic
	16 OSLabel
	4 BootBlockStart
	4 BootBlockCount
	4 Reserved
	512 BadgeBitmap
endstruct

const BootMagic 0x45544E41
const BootRM 0x24

const BootBottom 0x20000

externptr BootErrors (* table *)

externptr API (* table *)

externptr BootableDevs (* table *)

externptr NumBootableDevs (* var *)

extern AutoBoot { -- ok }

extern BootNode { devnode args -- ok }

extern BootUI { -- node }

extern AddBootable { -- }