.extern Puts
.extern Putc
.extern Putn
.extern Error
.extern Reset

.section text

ExceptionVector:
.global ExceptionVector
	la   a0, EPCName
	mfcr a1, epc
	jal  PrintInfo

	la   a0, ERSName
	mfcr a1, ers
	jal  PrintInfo

	la   a0, ECAUSEName
	mfcr a1, ecause
	jal  PrintInfo

	la   a0, BADADDRName
	mfcr a1, ebadaddr
	jal  PrintInfo

	mtcr ebadaddr, zero

	lui  a1, zero, 0x02000000
	mfcr t0, ecause
	or   a1, a1, t0
	la   a0, ExceptionString
	jal  Error

	j    Reset

;a0 - name
;a1 - value
PrintInfo:
	subi sp, sp, 8
	mov  long [sp], lr
	mov  long [sp + 4], s0

	jal  Puts

	mov  s0, a1

	la   a0, InfoString
	jal  Puts

	mov  a0, s0
	jal  Putn

	li   a0, 0xA
	jal  Putc

	mov  s0, long [sp + 4]
	mov  lr, long [sp]
	addi sp, sp, 8
	ret

.section data

EPCName:
	.ds "EPC\0"

ERSName:
	.ds "ERS\0"

ECAUSEName:
	.ds "ECAUSE\0"

BADADDRName:
	.ds "BADADDR\0"

InfoString:
	.ds ": \0"

ExceptionString:
	.ds "An unexpected exception occurred.\n\0"

.section bss

.bytes 1024 0
ExceptionStackTop: