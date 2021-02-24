.extern Puts

.extern Putc

.extern Putn

.extern Getc

.extern Reset

.extern FBDisplayCode

.section text

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
	beq v0, 'c', .out
	bne v0, 'x', .reset

	li t0, 0
	lui t1, 0x100000

.clear:
	beq t0, t1, .reset

	mov long [t0], 0

	add t0, t0, 4
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
	.ds "[c\0"

LLFWErrorString:
	.ds "\nFATAL ERROR! Cannot continue initialization:\n"
	.db 0x9
	.db 0x0

LLFWErrorStringB:
	.db 0x9
	.ds "EC: \0"

LLFWErrorStringC:
	.ds "Resetting on console input, or press 'c' to continue.\n\0"