.extern LLFWStackTop

.extern ExceptionVector

.extern Puts

.extern POST

.extern LoadBIOS

.extern Putn

RAMSlotZero === 0x10000004

Reset:
.global Reset
	lui rs, 0x80000000 ;reset ebus
	li ev, 0 ;clear exception vector

	la r1, RAMSlotZero
	l.l r1, r1, zero
	la r2, _bss_size
	bge r1, r2, .goodRAM ;continue if there's at least enough RAM to fit our bss section

	b Hang ;otherwise hang

.goodRAM:
	la sp, LLFWStackTop ;set stack

	la ev, ExceptionVector ;set exception vector

	;zero out bss
	la r2, _bss
	la r3, _bss_size
	add r4, r2, r3

.zero:
	beq r2, r4, .zdone

	s.l r2, zero, zero

	addi r2, r2, 4
	b .zero

.zdone:
	push r1
	la r1, HiString
	jal Puts
	pop r1

	jal POST ;self test

	jal LoadBIOS ;load bios image

	push r1
	la r1, HLRString
	jal Puts
	pop r1

	;pointer to last frame as defined by limn2k abi
	subi sp, sp, 8
	si.l sp, zero, 0 ;zero
	siio.l sp, 4, 0

	jalr r1

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