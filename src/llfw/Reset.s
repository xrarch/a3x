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

;this MUST be page-aligned!

ExceptionHandlers:
;vector 0 - nothing
	j    ExceptionVector

.align 256
;vector 1 - interrupt
	j    ExceptionVector

.align 256
;vector 2 - syscall
	j    ExceptionVector

.align 256
;vector 3 - nothing
	j    ExceptionVector

.align 256
;vector 4 - bus error
	j    ExceptionVector

.align 256
;vector 5 - NMI
	j    ExceptionVector

.align 256
;vector 6 - breakpoint
	j    ExceptionVector

.align 256
;vector 7 - illegal instruction
	j    ExceptionVector

.align 256
;vector 8 - privilege violation
	j    ExceptionVector

.align 256
;vector 9 - unaligned address
	j    ExceptionVector

.align 256
;vector 10 - nothing
	j    ExceptionVector

.align 256
;vector 11 - nothing
	j    ExceptionVector

.align 256
;vector 12 - page fault read
	j    ExceptionVector

.align 256
;vector 13 - page fault write
	j    ExceptionVector

.align 256
;vector 14 - nothing
	j    ExceptionVector

.align 256
;vector 15 - nothing
	j    ExceptionVector

.align 256

Reset:
.global Reset
	; invalidate caches

	li   t0, 3
	mtcr icachectrl, t0
	mtcr dcachectrl, t0

	la   t0, PBoardResetMagic
	mov  long [PBoardReset], t0, tmp=t1 ;reset ebus

	la   sp, LLFWStackTop ;set stack

	la   t0, ExceptionHandlers
	mtcr eb, t0 ;set exception vectors

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

	; invalidate icache again

	li   t0, 3
	mtcr icachectrl, t0

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

.bytes 1024 0
LLFWStackTop: