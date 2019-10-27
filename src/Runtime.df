#include "<df>/dragonfruit.h"

procedure _DumpStack (* -- *)

	"--sd--\n" Printf

	asm "

	mov r0, r5
	li r1, 0x1000
	li r2, 0x1000

.loop:
	cmp r0, r1
	bge .out

	subi r2, r2, 4

	lrr.l r3, r2

	push r0
	push r1
	push r2

	pushv r5, r3
	call Putx

	li r0, 0xA
	pushv r5, r0
	call Putc

	pop r2
	pop r1
	pop r0

	addi r0, r0, 4
	b .loop

.out:

	"

	"--end sd--\n" Printf
end