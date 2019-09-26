;very low-level reset code for limn1k cpu, reset vector specified in ROMHeader.s points to Reset routine
;special purpose registers are reset, the ROM is copied into RAM, and the main firmware procedure is called

.extern LLFWSerialPuts
.extern LLFWPOST
.extern FirmwareBase
.extern LLFWFault

Reset:
.global Reset
	li rs, 0x80000000 ;reset ebus
	cli ; clear interrupt queue
	li ivt, 0 ;reset ivt

	lri.l r0, 0x10000004 ;how much RAM is in slot 0?
	cmpi r0, 0x2000 ;if not at least 8kb,
	bl LLFWNoStack ;don't even try to set the stack pointer or show an error message.

	li ivt, LLFWFaults
	li sp, 0x2000

	;zero out bottom 8kb of RAM
	
	li r1, 0
.sloop:
	cmpi r1, 0x2000
	bge .sld

	sri.l r1, 0

	addi r1, r1, 4
	b .sloop

.sld:

	push r0

	li r0, LLFWHiString
	call LLFWSerialPuts

	pop r0

	call LLFWPOST

	call LLFWShadow

	li r0, LLFWHLRString
	call LLFWSerialPuts
	
	li r5, 0x1000
	call FirmwareBase
	b Hang

LLFWNoStack:

Hang:
	b Hang

LLFWShadow:
	li r0, LLFWShadowString
	call LLFWSerialPuts

	li r0, FirmwareBase
	li r1, 0x2000
	li r2, 0xFFFFFFF0

.loop:
	cmp r0, r2
	bge .done

	lrr.l r3, r0
	srr.l r1, r3

	addi r0, r0, 4
	addi r1, r1, 4
	b .loop

.done:
	ret

LLFWHLRString:
	.ds Jumping to high-level firmware!
	.db 0xA, 0x0

LLFWShadowString:
	.ds Shadowing ROM...
	.db 0xA, 0x0

LLFWHiString:
	.db 0xA
	.ds ==================================
	.db 0xA
	.ds low-level firmware for LIMNstation
	.db 0xA
	.ds ==================================
	.db 0xA, 0x0

;placeholder ivt
LLFWFaults:
	.dl LLFWFault, LLFWFault, LLFWFault, LLFWFault, LLFWFault, LLFWFault, LLFWFault, LLFWFault ;8
	.dl LLFWFault, LLFWFault, 0, 0, 0, 0, 0, 0 ;16
	.bytes 960 0 ;fill remainder of IVT