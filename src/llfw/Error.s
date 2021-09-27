.extern Puts
.extern Putc
.extern Putn
.extern Getc
.extern Reset
.extern memset

.extern FBDisplayCode

.section text

;a0 - error string
;a1 - error code
Error:
.global Error
	subi sp, sp, 12
	mov  long [sp], lr
	mov  long [sp + 4], s0
	mov  long [sp + 8], s1

	mov  s0, a0
	mov  s1, a1

	la   a0, LLFWErrorString
	jal  Puts

	mov  a0, s0
	jal  Puts

	la   a0, LLFWErrorStringB
	jal  Puts

	mov  a0, s1
	jal  Putn

	li   a0, 0xA
	jal  Putc

	la   a0, LLFWErrorStringC
	jal  Puts

	mov  a0, s1
	jal  FBDisplayCode

	jal  Getc
	
	subi t0, a0, 'c'
	beq  t0, .out

	subi t0, a0, 'x'
	bne  t0, .reset

	li   a0, 0x0 ;word
	la   a1, 0xFF000 ;size
	li   a2, 0x1000 ;ptr
	jal  memset

.reset:
	la   a0, LLFWTermClear
	jal  Puts

	j    Reset

.out:
	mov  s1, long [sp + 8]
	mov  s0, long [sp + 4]
	mov  lr, long [sp]
	addi sp, sp, 12

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