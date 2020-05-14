.extern Puts
.extern Putn
.extern Putc

.extern Error

.extern Reset

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
.end-struct

.struct Header
	4 FixupTableOffset
	4 FixupCount
	4 SectionOffset
	4 SectionSize
	4 LinkedAddress
.end-struct

LOFFMagic === 0x4C4F4646
LOFFArch === 2

;outputs:
;r1 - entry point
LoadBIOS:
.global LoadBIOS
	push lr
	push r4
	push r5
	push r6

	la r6, _data_end ;this is where the BIOS image should be in ROM
	lio.l r1, r6, LOFF_Magic
	la r5, 0x4C4F4646
	beq r1, r5, .valid1

	b .notvalid

.valid1:
	lio.l r1, r6, LOFF_Architecture
	beqi r1, LOFFArch, .valid

	b .notvalid

.valid:
	la r1, LoadString
	jal Puts

	lio.l r1, r6, LOFF_TextHeader
	add r1, r1, r6
	jal CopySection

	lio.l r1, r6, LOFF_DataHeader
	add r1, r1, r6
	jal CopySection

	lio.l r1, r6, LOFF_BSSHeader
	add r1, r1, r6
	lio.l r5, r1, Header_SectionSize
	lio.l r4, r1, Header_LinkedAddress

	add r5, r4, r5

.zero:
	beq r4, r5, .zdone

	s.l r4, zero, zero

	addi r4, r4, 4
	b .zero

.zdone:
	lio.l r1, r6, LOFF_EntrySymbol
	la r5, 0xFFFFFFFF
	beq r1, r5, .notvalid

	lio.l r5, r6, LOFF_SymbolTableOffset
	add r5, r5, r6

	muli r1, r1, Symbol_sizeof
	add r1, r1, r5

	lio.l r5, r1, Symbol_Section
	bnei r5, 1, .notvalid

	lio.l r1, r1, Symbol_Value

	lio.l r5, r6, LOFF_TextHeader
	add r5, r5, r6
	lio.l r4, r5, Header_LinkedAddress

	add r1, r1, r4

	pop r6
	pop r5
	pop r4
	pop lr
	ret

.notvalid:
	lui r2, 0x05000000
	la r1, InvalidString
	jal Error

	j Reset

;r1 - section header
;r6 - image offset
CopySection:
	push r2
	push r3
	push r4

	lio.l r2, r1, Header_SectionOffset
	add r2, r2, r6 ;r2 now contains the section's address

	lio.l r3, r1, Header_SectionSize
	lio.l r4, r1, Header_LinkedAddress

	add r3, r4, r3

.loop:
	beq r4, r3, .out

	l.l r1, zero, r2
	s.l r4, zero, r1

	addi r2, r2, 4
	addi r4, r4, 4
	b .loop

.out:
	pop r4
	pop r3
	pop r2
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
	.db 0xA, 0x0

InvalidString:
	.ds Payload isn't a valid LOFF image!
	.db 0xA, 0x0