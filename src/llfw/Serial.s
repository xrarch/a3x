SerialPortA === 0xF8000040
SerialPortB === 0xF8000044

;r1 - str
Puts:
.global Puts
	push lr
	push r2

.loop:
	l.b r2, r1, zero
	beq r2, zero, .out

	push r1
	mov r1, r2
	jal Putc
	pop r1

	addi r1, r1, 1
	b .loop

.out:
	pop r2
	pop lr
	ret

;outputs:
;r1 - char
Getc:
.global Getc
	push r2
	push r3
	push r4
	la r2, SerialPortA

	li r4, 0xFFFF
	
.busy:
	l.b r3, r2, zero
	bne r3, zero, .busy

	si.b r2, zero, 2
	lio.i r1, r2, 4

	beq r1, r4, .busy

	pop r4
	pop r3
	pop r2
	ret 

;r1 - char
Putc:
.global Putc
	push r2
	push r3
	la r2, SerialPortA

.wait:
	l.b r3, r2, zero
	bne r3, zero, .wait

	sio.l r2, 4, r1
	si.l r2, zero, 1

	pop r3
	pop r2
	ret

;r1 - number
Putn:
.global Putn
	push lr
	push r1
	push r2
	push r3

	mov r3, r1
	rshi r1, r1, 4
	modi r2, r3, 16
	beq r1, zero, .ldigit

	jal Putn

.ldigit:
	la r3, IntegerChars
	l.b r1, r3, r2

	jal Putc

	pop r3
	pop r2
	pop r1
	pop lr
	ret

.section data

IntegerChars:
	.ds 0123456789ABCDEF