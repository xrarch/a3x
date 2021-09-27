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

.define LOFFMagic 0x4C4F4635
.define LOFFArch  5

.section text

;outputs:
;a0 - entry point
LoadBIOS:
.global LoadBIOS
	subi sp, sp, 8
	mov  long [sp], lr
	mov  long [sp + 4], s0

	la   s0, _data_end ;this is where the BIOS image should be in ROM
	mov  t0, long [s0 + LOFF_Magic]
	la   t1, LOFFMagic
	sub  t0, t0, t1
	beq  t0, .valid1

	b    .notvalid

.valid1:
	mov  t0, long [s0 + LOFF_Architecture]
	subi t0, t0, LOFFArch
	beq  t0, .valid

	b    .notvalid

.valid:
	la   a0, LoadString
	jal  Puts

	mov  a1, s0
	mov  a0, long [s0 + LOFF_TextHeader]
	add  a0, a0, s0
	jal  CopySection

	mov  a1, s0
	mov  a0, long [s0 + LOFF_DataHeader]
	add  a0, a0, s0
	jal  CopySection

	mov  t0, long [s0 + LOFF_BSSHeader]
	add  t0, t0, s0
	mov  t1, long [t0 + Header_SectionSize]
	mov  t2, long [t0 + Header_LinkedAddress]

	li   a0, 0
	mov  a1, t1
	mov  a2, t2
	jal  memset

.zdone:
	mov  t0, long [s0 + LOFF_EntrySymbol]
	addi t1, t0, 1 ;compare with constant 0xFFFFFFFF
	beq  t1, .notvalid

	mov  t1, long [s0 + LOFF_SymbolTableOffset]
	add  t1, t1, s0

	li   t2, Symbol_sizeof
	mul  t0, t0, t2
	add  t0, t0, t1

	mov  t1, long [t0 + Symbol_Section]
	subi t2, t1, 1
	bne  t2, .notvalid

	mov  t0, long [t0 + Symbol_Value]
	mov  t1, long [s0 + LOFF_TextHeader]
	add  t1, t1, s0
	mov  t2, long [t1 + Header_LinkedAddress]

	add  s0, t0, t2

	la   a0, EntryString
	jal  Puts

	mov  a0, s0
	jal  Putn

	li   a0, 0xA
	jal  Putc

	mov  a0, s0

	mov  s0, long [sp + 4]
	mov  lr, long [sp]
	addi sp, sp, 8
	ret

.notvalid:
	lui  a1, zero, 0x05000000
	la   a0, InvalidString
	jal  Error

	j    Reset

;a0 - section header
;a1 - image offset
CopySection:
	mov  t0, long [a0 + Header_SectionOffset]
	add  t0, t0, a1 ;t0 now contains the section's address

	mov  t1, long [a0 + Header_SectionSize]
	mov  t2, long [a0 + Header_LinkedAddress]

	subi sp, sp, 4
	mov  long [sp], lr

	mov  a0, t1
	mov  a1, t0
	mov  a2, t2
	jal  memcpy
	
	mov  lr, long [sp]
	addi sp, sp, 4

.out:
	ret

.section data

TEXTName:
	.ds "text=\0"

DATAName:
	.ds "data=\0"

BSSName:
	.ds "bss=\0"

LoadString:
	.ds "Loading BIOS image... \0"

EntryString:
	.ds "entry @ 0x\0"

InvalidString:
	.ds "Payload isn't a valid LOFF image!\n\0"
