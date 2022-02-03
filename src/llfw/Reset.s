.extern LLFWStackTop

.extern ExceptionVector

.extern Puts

.extern FindFB

.extern POST

.extern LoadBIOS

.extern Putn

.extern Putc

.extern memset

.define RAMSlotZero 0x10000004

.define PBoardReset 0xF8800000
.define PBoardResetMagic 0xAABBCCDD

.section text

Reset:
.global Reset
	la   t0, PBoardResetMagic
	la   t1, PBoardReset
	mov  long [t1], t0 ;reset ebus

	mtcr evec,  zero ;clear exception vectors
	mtcr fwvec, zero

	la   t0, RAMSlotZero
	mov  s0, long [t0]

	la   t1, _bss_size
	slt  t0, s0, t1
	beq  t0, .goodRAM ;continue if there's at least enough RAM to fit our bss section

	j    Hang ;otherwise hang

.goodRAM:
	la   sp, LLFWStackTop ;set stack

	la   t0, ExceptionVector
	mtcr evec,  t0 ;set exception vectors
	mtcr fwvec, t0

	;zero out bss
	li   a0, 0
	la   a1, _bss_size
	la   a2, _bss
	jal  memset

	jal  FindFB

	la   a0, HiString
	jal  Puts

	mov  a0, s0
	jal  POST ;self test

	jal  LoadBIOS ;load bios image into RAM

	mov  s0, a0

	la   a0, HLRString
	jal  Puts

	;make phony pointer to last frame as defined by limn2500 abi
	;for the benefit of stack traces

	subi sp, sp, 8
	mov  long [sp], 0
	mov  long [sp + 4], 0

	jalr lr, s0, 0 ;jump into bios entry point

Hang:
	b    Hang

.ds "limn2600 BootROM, by Will"

.section data

HiString:
	.ds "\n===============================\nlow-level firmware for limn2600\n===============================\n\0"

HLRString:
	.ds "Jumping to high-level firmware!\n\n\0"

.section bss

.bytes 4096 0
LLFWStackTop: