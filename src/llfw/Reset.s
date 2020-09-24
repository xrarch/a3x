.extern LLFWStackTop

.extern ExceptionVector

.extern Puts

.extern FindFB

.extern POST

.extern LoadBIOS

.extern Putn

.extern Putc

RAMSlotZero === 0x10000004

Reset:
.global Reset
	lui rs, 0x80000000 ;reset ebus
	li ev, 0 ;clear exception vector

	la t0, RAMSlotZero
	l.l a0, t0, zero
	la t1, _bss_size
	bge a0, t1, .goodRAM ;continue if there's at least enough RAM to fit our bss section

	b Hang ;otherwise hang

.goodRAM:
	la sp, LLFWStackTop ;set stack

	la ev, ExceptionVector ;set exception vector

	;zero out bss
	la t0, _bss
	la t1, _bss_size
	add t3, t0, t1

.zero:
	beq t0, t3, .zdone

	s.l t0, zero, zero

	addi t0, t0, 4
	b .zero

.zdone:
	push a0
	jal FindFB

	la a0, HiString
	jal Puts
	pop a0

	jal POST ;self test

	jal LoadBIOS ;load bios image

	push v0
	la a0, HLRString
	jal Puts
	pop v0

	;pointer to last frame as defined by limn2k abi
	subi sp, sp, 8
	si.l sp, zero, 0 ;zero
	siio.l sp, 4, 0

	jalr v0

Hang:
	b Hang

.section data

HiString:
	.db 0xA
	.ds =============================
	.db 0xA
	.ds low-level firmware for limn2k
	.db 0xA
	.ds =============================
	.db 0xA, 0x0

HLRString:
	.ds Jumping to high-level firmware!
	.db 0xA, 0xA, 0x0

.section bss

.bytes 4096 0
LLFWStackTop: