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

.section text

Reset:
.global Reset
	lui rs, 0x80000000 ;reset ebus
	li ev, 0 ;clear exception vector
	li tlbv, 0

	la t0, RAMSlotZero
	mov s0, long [t0]

	la t1, _bss_size
	slt at, s0, t1
	beq at, zero, .goodRAM ;continue if there's at least enough RAM to fit our bss section

	b Hang ;otherwise hang

.goodRAM:
	la sp, LLFWStackTop ;set stack

	la ev, ExceptionVector ;set exception vector
	la tlbv, ExceptionVector

	;zero out bss
	li a0, 0
	la a1, _bss_size
	la a2, _bss
	jal memset

	jal FindFB

	la a0, HiString
	jal Puts

	mov a0, s0
	jal POST ;self test

	jal LoadBIOS ;load bios image

	push v0
	la a0, HLRString
	jal Puts
	pop v0

	;pointer to last frame as defined by limn2k abi
	sub sp, sp, 8
	mov long [sp], 0
	mov long [sp + 4], 0

	jal v0

Hang:
	b Hang

.section data

HiString:
	.ds "\n=============================\nlow-level firmware for limn2k\n=============================\n\0"

HLRString:
	.ds "Jumping to high-level firmware!\n\n\0"

.section bss

.bytes 4096 0
LLFWStackTop: