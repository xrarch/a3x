.define EBusSlotsStart 0xC0000000
.define EBusSlotSpace  0x8000000

.define LIMNGFXSlotMID 0x4B494E34
.define LGVRAMOffset   0x100000
.define LGRegScreen    0x3000

.extern memset

.section text

FindFB:
.global FindFB
	lui t0, EBusSlotsStart
	li t1, 7
	la t2, LIMNGFXSlotMID
	lui t3, EBusSlotSpace

.loop:
	mov t4, long [t0 + 4]
	beq t4, t2, .found

	add t0, t0, t3
	sub t1, t1, 1

	bne t1, zero, .loop

	b .out

.found:
	lui t1, LGVRAMOffset
	add t1, t0, t1
	la t2, FBAddress
	mov long [t2], t1

	li t2, LGRegScreen
	mov t1, long [t0 + t2]
	li t3, 0xFFF
	and t2, t1, t3
	la t0, FBWidth
	mov long [t0], t2

	rsh t3, t1, 12
	la t0, FBHeight
	mov long [t0], t3

	mul t2, t2, t3
	lsh t2, t2, 1
	la t0, FBSize
	mov long [t0], t2

.out:
	ret

;a0 - code
FBDisplayCode:
.global FBDisplayCode
	push lr
	push s0

	la t0, FBAddress
	mov s0, long [t0]
	beq s0, zero, .out

	push a0
	jal FBClear
	pop a0

	la t0, FBWidth
	mov t0, long [t0]

	la t1, FBHeight
	mov t1, long [t1]

	rsh t2, t0, 1
	sub t2, t2, 32

	rsh t1, t1, 1
	sub t1, t1, 8

	mul t1, t1, t0
	add t1, t1, t2

	lsh t1, t1, 1
	add s0, s0, t1

	add s0, s0, 112

	lsh t0, t0, 1
	sub a1, t0, 16 ;width of a character

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
	rsh a0, a0, 4
	and t1, t0, 15
	beq a0, zero, .ldigit

	push t1
	push a1
	push a2
	sub a2, a2, 16
	jal FBPutx
	pop a2
	pop a1
	pop t1

.ldigit:
	la t0, ErrorcodeFont
	lsh t1, t1, 4 ;multiply by 16 to get offset in font
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
	sub t0, t0, 1

	li t1, 8

	mov t2, byte [a0]

.xloop:
	sub t1, t1, 1

	rsh t3, t2, t1
	and t3, t3, 1
	beq t3, zero, .nopix

	mov int [a2], t4

.nopix:
	add a2, a2, 2
	bne t1, zero, .xloop

	add a0, a0, 1
	add a2, a2, a1
	bne t0, zero, .yloop

	ret

FBClear:
	push lr

	la a2, FBAddress
	mov a2, long [a2]

	la a1, FBSize
	mov a1, long [a1]

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