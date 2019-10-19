struct BootRecord
	4 Magic
	1 ret
	16 OSLabel
	4 BootBlockStart
	4 BootBlockCount
endstruct

const BootMagic 0x45544E41
const BootRM 0x24

const BootBottom 0x40000

externconst BootErrors (* table *)

externconst API (* table *)

extern DevBootable (* dnode -- bootable? *)

extern DevBootableR (* dnode -- brecord bootable? *)

extern AutoBoot (* -- ok? *)

extern BootNode (* devnode args -- ok? *)

extern BootUI (* -- *)