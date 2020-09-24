.extern Puts
.extern Putc
.extern Putn
.extern Error

ExceptionVector:
.global ExceptionVector
	subi.i sp, 112
	sgpr sp
	push epc
	push ers
	push lr

	la a0, EPCName
	mov a1, epc
	jal PrintInfo

	la a0, ERSName
	mov a1, ers
	jal PrintInfo

	la a0, ECAUSEName
	mov a1, ecause
	jal PrintInfo

	la a0, BADADDRName
	mov a1, badaddr
	jal PrintInfo

	li badaddr, 0

	lui a1, 0x02000000
	or a1, a1, ecause
	la a0, ExceptionString
	jal Error

	pop lr
	pop ers
	pop epc
	lgpr sp
	addi.i sp, 112
	rfe

;a0 - name
;a1 - value
PrintInfo:
	push lr
	push s0

	jal Puts

	mov s0, a1

	la a0, InfoString
	jal Puts

	mov a0, s0
	jal Putn

	li a0, 0xA
	jal Putc

	pop s0
	pop lr
	ret

.section data

EPCName:
	.ds EPC
	.db 0x0

ERSName:
	.ds ERS
	.db 0x0

ECAUSEName:
	.ds ECAUSE
	.db 0x0

BADADDRName:
	.ds BADADDR
	.db 0x0

InfoString:
	.ds : 
	.db 0x0

ExceptionString:
	.ds An unexpected exception occurred.
	.db 0xA, 0x0

.section bss

.bytes 1024 0
ExceptionStackTop: