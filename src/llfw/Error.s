.extern Puts

.extern Putc

.extern Putn

.extern Getc

.extern Reset

.extern FBDisplayCode

;a0 - error string
;a1 - error code
Error:
.global Error
	push lr
	push s0
	push s1

	mov s0, a0
	mov s1, a1

	la a0, LLFWErrorString
	jal Puts

	mov a0, s0
	jal Puts

	la a0, LLFWErrorStringB
	jal Puts

	mov a0, s1
	jal Putn

	li a0, 0xA
	jal Putc

	la a0, LLFWErrorStringC
	jal Puts

	mov a0, s1
	jal FBDisplayCode

	jal Getc
	beqi v0, "c", .out
	bnei v0, "x", .reset

	li t0, 0
	lui t1, 0x100000

.clear:
	beq t0, t1, .reset

	si.l t0, zero, 0

	addi t0, t0, 4
	b .clear

.reset:
	la a0, LLFWTermClear
	jal Puts

	j Reset

.out:
	pop s1
	pop s0
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