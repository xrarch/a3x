.define SerialPortA 0xF8000040
.define SerialPortB 0xF8000044

.section text

;a0 - str
Puts:
.global Puts
	subi sp, sp, 8
	mov  long [sp], lr
	mov  long [sp + 4], s0

	mov  s0, a0

.loop:
	mov  t0, byte [s0]
	beq  t0, zero, .out

	mov  a0, t0
	jal  Putc

	addi s0, s0, 1
	b    .loop

.out:
	mov  s0, long [sp + 4]
	mov  lr, long [sp]
	addi sp, sp, 8
	ret

;outputs:
;a0 - char
Getc:
.global Getc
	la   t0, SerialPortA
	li   t1, 0xFFFF
	
.busy:
	mov  t2, byte [t0]
	bne  t2, zero, .busy

	mov  byte [t0], 2
	mov  a0, int [t0 + 4]

	beq  a0, t1, .busy

	ret 

;a0 - char
Putc:
.global Putc
	la   t0, SerialPortA

.wait:
	mov  t1, byte [t0]
	bne  t1, zero, .wait

	mov  long [t0 + 4], a0
	mov  long [t0], 1

	ret

;a0 - number
Putn:
.global Putn
	subi sp, sp, 8
	mov  long [sp], lr
	mov  long [sp + 4], s0

	mov  t0, a0
	rshi a0, a0, 4
	andi s0, t0, 15
	beq  a0, zero, .ldigit

	jal  Putn

.ldigit:
	la   t0, IntegerChars
	mov  a0, byte [t0 + s0]
	jal  Putc

	mov  s0, long [sp + 4]
	mov  lr, long [sp]
	addi sp, sp, 8
	ret

.section data

IntegerChars:
	.ds "0123456789ABCDEF"