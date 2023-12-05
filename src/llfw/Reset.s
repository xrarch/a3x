.extern LLFWStackTop

.extern ExceptionVector

.extern Puts

.extern FindFB

.extern POST

.extern LoadBIOS

.extern Putn

.extern Putc

.extern memset

.define PBoardReset 0xF8800000
.define PBoardResetMagic 0xAABBCCDD

.section text

Reset:
.global Reset
	cachei 5 ;invalidate dcache and icache (but don't writeback dcache)

	la   t0, PBoardResetMagic
	mov  long [PBoardReset], t0, tmp=t1 ;reset ebus

	mtcr evec,  zero ;clear exception vectors

	la   sp, LLFWStackTop ;set stack

	la   t0, ExceptionVector
	mtcr evec,  t0 ;set exception vectors

	;zero out bss
	li   a0, 0
	la   a1, _bss_size
	la   a2, _bss
	jal  memset

	jal  FindFB

	la   a0, HiString
	jal  Puts

	jal  POST ;self test

	jal  LoadBIOS ;load bios image into RAM

	mov  s0, a0

	la   a0, HLRString
	jal  Puts

	cachei 3

	;make phony pointer to last frame as defined by limn2500 abi
	;for the benefit of stack traces

	subi sp, sp, 8
	mov  long [sp], 0
	mov  long [sp + 4], 0

	jalr lr, s0, 0 ;jump into bios entry point

Hang:
	b    Hang

.ds "XR/17032 BootROM, by Will"

.section data

HiString:
	.ds "\n===============================\nlow-level firmware for XR/17032\n===============================\n\0"

HLRString:
	.ds "Jumping to high-level firmware!\n\n\0"

.section bss

.bytes 4096 0
LLFWStackTop: