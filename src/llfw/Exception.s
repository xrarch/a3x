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

	la r1, EPCName
	mov r2, epc
	jal PrintInfo

	la r1, ERSName
	mov r2, ers
	jal PrintInfo

	la r1, ECAUSEName
	mov r2, ecause
	jal PrintInfo

	la r1, BADADDRName
	mov r2, badaddr
	jal PrintInfo

	li badaddr, 0

	lui r2, 0x02000000
	or r2, r2, ecause
	la r1, ExceptionString
	jal Error

	pop lr
	pop ers
	pop epc
	lgpr sp
	addi.i sp, 112
	rfe

;r1 - name
;r2 - value
PrintInfo:
	push lr

	jal Puts

	la r1, InfoString
	jal Puts

	mov r1, r2
	jal Putn

	li r1, 0xA
	jal Putc

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