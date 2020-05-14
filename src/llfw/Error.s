.extern Puts

.extern Putc

.extern Putn

.extern Getc

.extern Reset

;r1 - error string
;r2 - error code
Error:
.global Error
	push lr

	push r1
	la r1, LLFWErrorString
	jal Puts
	pop r1

	jal Puts

	la r1, LLFWErrorStringB
	jal Puts

	mov r1, r2
	jal Putn

	li r1, 0xA
	jal Putc

	la r1, LLFWErrorStringC
	jal Puts

	jal Getc
	beqi r1, "c", .out
	bnei r1, "x", .reset

	li r1, 0
	lui r2, 0x100000

.clear:
	beq r1, r2, .reset

	si.l r1, zero, 0

	addi r1, r1, 4
	b .clear

.reset:
	la r1, LLFWTermClear
	jal Puts

	j Reset

.out:
	pop lr
	ret

.section data

LLFWTermClear:
	.db 0x1B
	.ds [c
	.db 0x0

LLFWErrorString:
	.db 0xA
	.ds FATAL ERROR! Cannot continue initialization:
	.db 0xA, 0x9, 0x0

LLFWErrorStringB:
	.db 0x9
	.ds EC: 
	.db 0x0

LLFWErrorStringC:
	.ds Resetting on console input, or press 'c' to continue.
	.db 0xA, 0x0