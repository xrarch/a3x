EBusSlotsStart === 0xC0000000
EBusSlotSpace === 0x8000000

LIMNGFXSlotMID === 0x4B494E34
LGVRAMOffset === 0x100000
LGRegScreen === 0x3000

.extern memset

FindFB:
.global FindFB
	lui t0, EBusSlotsStart
	li t1, 7
	la t2, LIMNGFXSlotMID
	lui t3, EBusSlotSpace

.loop:
	lio.l t4, t0, 4
	beq t4, t2, .found

	add t0, t0, t3
	subi t1, t1, 1

	bne t1, zero, .loop

	b .out

.found:
	lui t1, LGVRAMOffset
	add t1, t0, t1
	la t2, FBAddress
	s.l t2, zero, t1

	li t2, LGRegScreen
	l.l t1, t0, t2
	li t3, 0xFFF
	and t2, t1, t3
	la t0, FBWidth
	s.l t0, zero, t2

	rshi t3, t1, 12
	la t0, FBHeight
	s.l t0, zero, t3

	mul t2, t2, t3
	lshi t2, t2, 1
	la t0, FBSize
	s.l t0, zero, t2

.out:
	ret

;a0 - code
FBDisplayCode:
.global FBDisplayCode
	push lr
	push s0

	la t0, FBAddress
	l.l s0, t0, zero
	beq s0, zero, .out

	push a0
	jal FBClear
	pop a0

	la t0, FBWidth
	l.l t0, t0, zero

	la t1, FBHeight
	l.l t1, t1, zero

	rshi t2, t0, 1
	subi t2, t2, 32

	rshi t1, t1, 1
	subi t1, t1, 8

	mul t1, t1, t0
	add t1, t1, t2

	lshi t1, t1, 1
	add s0, s0, t1

	addi s0, s0, 112

	lshi t0, t0, 1
	subi a1, t0, 16 ;width of a character

	mov a2, s0

	jal FBPutx

.out:
	pop s0
	pop lr
	ret

;a0 - number
;a1 - fb modulo
;a2 - start addr
FBPutx:
	push lr

	mov t0, a0
	rshi a0, a0, 4
	modi t1, t0, 16
	beq a0, zero, .ldigit

	push t1
	push a1
	push a2
	subi a2, a2, 16
	jal FBPutx
	pop a2
	pop a1
	pop t1

.ldigit:
	la t0, ErrorcodeFont
	lshi t1, t1, 4 ;multiply by 16 to get offset in font
	add a0, t0, t1
	jal FBDrawGlyph

	pop lr
	ret

;a0 - glyph addr
;a1 - fb modulo
;a2 - start addr
FBDrawGlyph:
	li t0, 16

	li t4, 0x7FFF

.yloop:
	subi t0, t0, 1

	li t1, 8

	l.b t2, a0, zero

.xloop:
	subi t1, t1, 1

	rsh t3, t2, t1
	andi t3, t3, 1
	beq t3, zero, .nopix

	s.i a2, zero, t4

.nopix:
	addi a2, a2, 2
	bne t1, zero, .xloop

	addi a0, a0, 1
	add a2, a2, a1
	bne t0, zero, .yloop

	ret

FBClear:
	push lr

	la a2, FBAddress
	l.l a2, a2, zero

	la a1, FBSize
	l.l a1, a1, zero

	la a0, 0x082E082E

	jal memset

	pop lr
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