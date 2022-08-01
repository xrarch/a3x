.extern Puts
.extern Putn
.extern Putc

.extern Error

.extern Reset

.extern memcpy
.extern memset

;we assume here that text, data, and bss sections will be 0, 1, and 2
;respectively.

.struct XLOFF
	4 Magic
	4 SymbolTableOffset
	4 SymbolCount
	4 StringTableOffset
	4 StringTableSize
	4 TargetArchitecture
	4 EntrySymbol
	4 Flags
	4 Timestamp
	4 SectionTableOffset
	4 SectionCount
	4 ImportTableOffset
	4 ImportCount
	4 HeadLength
.end-struct

.struct Symbol
	4 NameOffset
	4 Value
	2 SectionIndexI
	1 TypeB
	1 FlagsB
.end-struct

.struct SectionHeader
	4 NameOffset
	4 DataOffset
	4 DataSize
	4 VirtualAddress
	4 RelocTableOffset
	4 RelocCount
	4 Flags
	0 SIZEOF
.end-struct

.define XLOFFMagic 0x99584F46
.define XLOFFArch  1

.section text

;outputs:
;a0 - entry point
LoadBIOS:
.global LoadBIOS
	subi sp, sp, 8
	mov  long [sp], lr
	mov  long [sp + 4], s0

	la   s0, _data_end ;this is where the BIOS image should be in ROM
	mov  t0, long [s0 + XLOFF_Magic]
	la   t1, XLOFFMagic
	sub  t0, t0, t1
	beq  t0, .valid1

	b    .notvalid

.valid1:
	mov  t0, long [s0 + XLOFF_TargetArchitecture]
	subi t0, t0, XLOFFArch
	beq  t0, .valid

	b    .notvalid

.valid:
	la   a0, LoadString
	jal  Puts

	mov  a1, s0
	mov  a0, long [s0 + XLOFF_SectionTableOffset]
	add  a0, a0, s0
	jal  CopySection

	mov  a1, s0
	mov  a0, long [s0 + XLOFF_SectionTableOffset]
	addi a0, a0, SectionHeader_SIZEOF
	add  a0, a0, s0
	jal  CopySection

	mov  t0, long [s0 + XLOFF_SectionTableOffset]
	addi t0, t0, SectionHeader_SIZEOF
	addi t0, t0, SectionHeader_SIZEOF
	add  t0, t0, s0
	mov  t1, long [t0 + SectionHeader_DataSize]
	mov  t2, long [t0 + SectionHeader_VirtualAddress]

	li   a0, 0
	mov  a1, t1
	mov  a2, t2
	jal  memset

.zdone:
	mov  t0, long [s0 + XLOFF_EntrySymbol]
	addi t1, t0, 1 ;compare with constant 0xFFFFFFFF
	beq  t1, .notvalid

	mov  t1, long [s0 + XLOFF_SymbolTableOffset]
	add  t1, t1, s0

	li   t2, Symbol_sizeof
	mul  t0, t0, t2
	add  t0, t0, t1

	mov  t1, int [t0 + Symbol_SectionIndexI]
	bne  t1, .notvalid

	mov  t0, long [t0 + Symbol_Value]
	mov  t1, long [s0 + XLOFF_SectionTableOffset]
	add  t1, t1, s0
	mov  t2, long [t1 + SectionHeader_VirtualAddress]

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
	mov  t0, long [a0 + SectionHeader_DataOffset]
	add  t0, t0, a1 ;t0 now contains the section's address

	mov  t1, long [a0 + SectionHeader_DataSize]
	mov  t2, long [a0 + SectionHeader_VirtualAddress]

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
