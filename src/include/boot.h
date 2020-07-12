struct BootRecord
	4 Magic
	16 OSLabel
	4 BootBlockStart
	4 BootBlockCount
endstruct

const BootMagic 0x45544E41
const BootRM 0x24

const BootBottom 0x40000

externptr BootErrors (* table *)

externptr API (* table *)

extern DevBootable { devnode -- bootable }

extern DevBootableR { devnode -- brecord bootable }

extern AutoBoot { -- ok }

extern BootNode { devnode args -- ok }

extern BootUI { -- }