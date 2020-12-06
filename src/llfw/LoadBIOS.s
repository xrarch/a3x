.extern Puts
.extern Putn
.extern Putc

.extern Error

.extern Reset

.extern memcpy
.extern memset

.struct LOFF
	4 Magic
	4 SymbolTableOffset
	4 SymbolCount
	4 StringTableOffset
	4 StringTableSize
	4 Architecture
	4 EntrySymbol
	4 Stripped
	28 Reserved
	4 TextHeader
	4 DataHeader
	4 BSSHeader
.end-struct

.struct Symbol
	4 NameOffset
	4 Section
	4 Type
	4 Value
	4 ImportIndex
.end-struct

.struct Header
	4 FixupTableOffset
	4 FixupCount
	4 SectionOffset
	4 SectionSize
	4 LinkedAddress
.end-struct

LOFFMagic === 0x4C4F4634
LOFFArch === 2

;outputs:
;v0 - entry point
LoadBIOS:
.global LoadBIOS
	push lr
	push s0

	la s0, _data_end ;this is where the BIOS image should be in ROM
	lio.l t0, s0, LOFF_Magic
	la t1, LOFFMagic
	beq t0, t1, .valid1

	b .notvalid

.valid1:
	lio.l t0, s0, LOFF_Architecture
	beqi t0, LOFFArch, .valid

	b .notvalid

.valid:
	la a0, LoadString
	jal Puts

	mov a1, s0
	lio.l a0, s0, LOFF_TextHeader
	add a0, a0, s0
	jal CopySection

	mov a1, s0
	lio.l a0, s0, LOFF_DataHeader
	add a0, a0, s0
	jal CopySection

	lio.l t0, s0, LOFF_BSSHeader
	add t0, t0, s0
	lio.l t1, t0, Header_SectionSize
	lio.l t2, t0, Header_LinkedAddress

	li a0, 0
	mov a1, t1
	mov a2, t2
	jal memset

.zdone:
	lio.l t0, s0, LOFF_EntrySymbol
	la t1, 0xFFFFFFFF
	beq t0, t1, .notvalid

	lio.l t1, s0, LOFF_SymbolTableOffset
	add t1, t1, s0

	muli t0, t0, Symbol_sizeof
	add t0, t0, t1

	lio.l t1, t0, Symbol_Section
	bnei t1, 1, .notvalid

	lio.l t0, t0, Symbol_Value

	lio.l t1, s0, LOFF_TextHeader
	add t1, t1, s0
	lio.l t2, t1, Header_LinkedAddress

	add v0, t0, t2

	push v0
	la a0, EntryString
	jal Puts
	pop a0
	push a0
	jal Putn
	li a0, 0xA
	jal Putc
	pop v0

	pop s0
	pop lr
	ret

.notvalid:
	lui a1, 0x05000000
	la a0, InvalidString
	jal Error

	j Reset

;a0 - section header
;a1 - image offset
CopySection:
	lio.l t0, a0, Header_SectionOffset
	add t0, t0, a1 ;t0 now contains the section's address

	lio.l t1, a0, Header_SectionSize
	lio.l t2, a0, Header_LinkedAddress

	push lr
	mov a0, t1
	mov a1, t0
	mov a2, t2
	jal memcpy
	pop lr

.out:
	ret

.section data

TEXTName:
	.ds text=
	.db 0x0

DATAName:
	.ds data=
	.db 0x0

BSSName:
	.ds bss=
	.db 0x0

LoadString:
	.ds Loading BIOS image... 
	.db 0x0

EntryString:
	.ds entry @ 0x
	.db 0x0

InvalidString:
	.ds Payload isn't a valid LOFF image!
	.db 0xA, 0x0
