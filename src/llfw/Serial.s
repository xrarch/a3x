SerialPortA === 0xF8000040
SerialPortB === 0xF8000044

;a0 - str
Puts:
.global Puts
	push lr

.loop:
	l.b t0, a0, zero
	beq t0, zero, .out

	push a0
	mov a0, t0
	jal Putc
	pop a0

	addi a0, a0, 1
	b .loop

.out:
	pop lr
	ret

;outputs:
;v0 - char
Getc:
.global Getc
	la t0, SerialPortA
	li t1, 0xFFFF
	
.busy:
	l.b t2, t0, zero
	bne t2, zero, .busy

	si.b t0, zero, 2
	lio.i t3, t0, 4

	beq t3, t1, .busy

	ret 

;a0 - char
Putc:
.global Putc
	la t0, SerialPortA

.wait:
	l.b t1, t0, zero
	bne t1, zero, .wait

	sio.l t0, 4, a0
	si.l t0, zero, 1

	ret

;a0 - number
Putn:
.global Putn
	push lr

	mov t0, a0
	rshi a0, a0, 4
	modi t1, t0, 16
	beq a0, zero, .ldigit

	push t1
	jal Putn
	pop t1

.ldigit:
	la t0, IntegerChars
	l.b a0, t0, t1
	jal Putc

	pop lr
	ret

.section data

IntegerChars:
	.ds 0123456789ABCDEF