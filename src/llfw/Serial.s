.define SerialPortA 0xF8000040
.define SerialPortB 0xF8000044

.section text

;a0 - str
Puts:
.global Puts
	push lr

.loop:
	mov t0, byte [a0]
	beq t0, zero, .out

	push a0
	mov a0, t0
	jal Putc
	pop a0

	add a0, a0, 1
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
	mov t2, byte [t0]
	bne t2, zero, .busy

	mov byte [t0], 2
	mov t3, int [t0 + 4]

	beq t3, t1, .busy

	ret 

;a0 - char
Putc:
.global Putc
	la t0, SerialPortA

.wait:
	mov t1, byte [t0]
	bne t1, zero, .wait

	mov long [t0 + 4], a0
	mov long [t0], 1

	ret

;a0 - number
Putn:
.global Putn
	push lr

	mov t0, a0
	rsh a0, a0, 4
	and t1, t0, 15
	beq a0, zero, .ldigit

	push t1
	jal Putn
	pop t1

.ldigit:
	la t0, IntegerChars
	mov a0, byte [t0 + t1]
	jal Putc

	pop lr
	ret

.section data

IntegerChars:
	.ds "0123456789ABCDEF"