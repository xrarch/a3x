.define EBusSlotsStart 0xC0000000
.define EBusSlotSpace  0x8000000

.define LIMNGFXSlotMID 0x4B494E35
.define LGVRAMOffset   0x100000
.define LGRegScreen    0x3000

.extern memset

.section text

FindFB:
.global FindFB
	lui  t0, zero, EBusSlotsStart
	li   t1, 7
	la   t2, LIMNGFXSlotMID
	lui  t3, zero, EBusSlotSpace

.loop:
	mov  t4, long [t0 + 4]
	sub  t4, t4, t2
	beq  t4, .found

	add  t0, t0, t3
	subi t1, t1, 1

	bne  t1, .loop

	b    .out

.found:
	lui  t1, zero, LGVRAMOffset
	add  t1, t0, t1
	la   t2, FBAddress
	mov  long [t2], t1

	li   t2, LGRegScreen
	mov  t1, long [t0 + t2]
	li   t3, 0xFFF
	and  t2, t1, t3
	la   t0, FBWidth
	mov  long [t0], t2

	rshi t3, t1, 12
	la   t0, FBHeight
	mov  long [t0], t3

	mul  t2, t2, t3
	lshi t2, t2, 1
	la   t0, FBSize
	mov  long [t0], t2

.out:
	ret

;a0 - code
FBDisplayCode:
.global FBDisplayCode
	subi sp, sp, 12
	mov  long [sp], lr
	mov  long [sp + 4], s0
	mov  long [sp + 8], s1

	la   t0, FBAddress
	mov  s0, long [t0]
	beq  s0, .out

	mov  s1, a0

	jal  FBClear

	la   t0, FBWidth
	mov  t0, long [t0]

	la   t1, FBHeight
	mov  t1, long [t1]

	rshi t2, t0, 1
	subi t2, t2, 32

	rshi t1, t1, 1
	subi t1, t1, 8

	mul  t1, t1, t0
	add  t1, t1, t2

	lshi t1, t1, 1
	add  s0, s0, t1

	addi s0, s0, 112

	lshi t0, t0, 1
	subi a1, t0, 16 ;width of a character

	mov  a0, s1
	mov  a2, s0

	jal  FBPutx

.out:
	mov  s1, long [sp + 8]
	mov  s0, long [sp + 4]
	mov  lr, long [sp]
	addi sp, sp, 12

	ret

;a0 - number
;a1 - fb modulo
;a2 - start addr
FBPutx:
	subi sp, sp, 16
	mov  long [sp], lr
	mov  long [sp + 4], t1
	mov  long [sp + 8], a1
	mov  long [sp + 12], a2

	mov  t0, a0
	rshi a0, a0, 4
	andi t1, t0, 15
	beq  a0, .ldigit

	subi a2, a2, 16
	jal  FBPutx
	addi a2, a2, 16

.ldigit:
	la   t0, ErrorcodeFont
	lshi t1, t1, 4 ;multiply by 16 to get offset in font
	add  a0, t0, t1
	jal  FBDrawGlyph

	mov  a2, long [sp + 12]
	mov  a1, long [sp + 8]
	mov  t1, long [sp + 4]
	mov  lr, long [sp]
	addi sp, sp, 16
	ret

;a0 - glyph addr
;a1 - fb modulo
;a2 - start addr
FBDrawGlyph:
	li   t0, 16

	li   t4, 0x7FFF

.yloop:
	subi t0, t0, 1

	li   t1, 8

	mov  t2, byte [a0]

.xloop:
	subi t1, t1, 1

	rsh  t3, t2, t1
	andi t3, t3, 1
	beq  t3, .nopix

	mov  int [a2], t4

.nopix:
	addi a2, a2, 2
	bne  t1, .xloop

	addi a0, a0, 1
	add  a2, a2, a1
	bne  t0, .yloop

	ret

FBClear:
	subi sp, sp, 4
	mov  long [sp], lr

	la   a2, FBAddress
	mov  a2, long [a2]

	la   a1, FBSize
	mov  a1, long [a1]

	la   a0, 0x082E082E

	jal  memset

	mov  lr, long [sp]
	addi sp, sp, 4
	ret

.section data

ErrorcodeFont:
	.static error.bmp

.section bss

FBSize:
	.dl 0

FBWidth:
	.dl 0

FBHeight:
	.dl 0

FBAddress:
	.dl 0