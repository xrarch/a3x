;a0 - word
;a1 - size
;a2 - ptr
memset:
.global memset
	bne a1, zero, .gzero

	ret

.gzero:
	xori t1, a2, 3
	addi t1, t1, 1
	andi t1, t1, 3

	beq t1, zero, .fdone

	mov t2, a0

	blt t1, a1, .goodlen

	mov t1, a1

.goodlen:
	sub a1, a1, t1

.fu:
	s.b a2, zero, t2

	rshi t2, t2, 8

	addi a2, a2, 1
	subi t1, t1, 1
	bne t1, zero, .fu

.fdone:
	;ptr is now aligned

	rshi t1, a1, 6 ;do 64 bytes each loop

	beq t1, zero, .b64done

.b64:
	s.l   a2, zero, a0
	sio.l a2, 4,    a0
	sio.l a2, 8,    a0
	sio.l a2, 12,   a0
	sio.l a2, 16,   a0
	sio.l a2, 20,   a0
	sio.l a2, 24,   a0
	sio.l a2, 28,   a0
	sio.l a2, 32,   a0
	sio.l a2, 36,   a0
	sio.l a2, 40,   a0
	sio.l a2, 44,   a0
	sio.l a2, 48,   a0
	sio.l a2, 52,   a0
	sio.l a2, 56,   a0
	sio.l a2, 60,   a0

	addi a2, a2, 64
	subi t1, t1, 1
	bne t1, zero, .b64

.b64done:
	andi t1, a1, 63

	rshi t1, t1, 2 ;do 4 bytes each loop

	beq t1, zero, .b4done

.b4:
	s.l a2, zero, a0

	addi a2, a2, 4
	subi t1, t1, 1
	bne t1, zero, .b4

.b4done:
	andi t1, a1, 3 ;do 1 byte each loop

	beq t1, zero, .b1done

.b1:
	s.b a2, zero, a0

	rshi a0, a0, 8

	addi a2, a2, 1
	subi t1, t1, 1
	bne t1, zero, .b1

.b1done:
	ret

;a0 - sz
;a1 - src
;a2 - dest
memcpy:
.global memcpy
	beq a0, zero, .zerosize

	xor t0, a1, a2

	andi t1, t0, 1
	beq t1, zero, .aligned_with_eachother

	b .unaligned

.zerosize:
	ret

.aligned_with_eachother:
	xori t1, a1, 3
	addi t1, t1, 1
	andi t1, t1, 3

	beq t1, zero, .fdone

	blt t1, a0, .goodlen

	mov t1, a0

.goodlen:
	sub a0, a0, t1

.fu:
	l.b t2, a1, zero
	s.b a2, zero, t2

	addi a1, a1, 1
	addi a2, a2, 1
	subi t1, t1, 1
	bne t1, zero, .fu

.fdone:
	andi t1, t0, 3
	beq t1, zero, .aligned32

.aligned16:
	rshi t0, a0, 6 ;do 64 bytes each loop

	beq t0, zero, .copy16_by_64done

.copy16_by_64:
	l.i   t1, a1, zero
	lio.i t2, a1, 2
	lio.i t3, a1, 4
	lio.i t4, a1, 6

	s.i   a2, zero, t1
	sio.i a2, 2,    t2
	sio.i a2, 4,    t3
	sio.i a2, 6,    t4

	lio.i t1, a1, 8
	lio.i t2, a1, 10
	lio.i t3, a1, 12
	lio.i t4, a1, 14

	sio.i a2, 8,  t1
	sio.i a2, 10, t2
	sio.i a2, 12, t3
	sio.i a2, 14, t4

	lio.i t1, a1, 16
	lio.i t2, a1, 18
	lio.i t3, a1, 20
	lio.i t4, a1, 22

	sio.i a2, 16, t1
	sio.i a2, 18, t2
	sio.i a2, 20, t3
	sio.i a2, 22, t4

	lio.i t1, a1, 24
	lio.i t2, a1, 26
	lio.i t3, a1, 28
	lio.i t4, a1, 30

	sio.i a2, 24, t1
	sio.i a2, 26, t2
	sio.i a2, 28, t3
	sio.i a2, 30, t4

	lio.i t1, a1, 32
	lio.i t2, a1, 34
	lio.i t3, a1, 36
	lio.i t4, a1, 38

	sio.i a2, 32, t1
	sio.i a2, 34, t2
	sio.i a2, 36, t3
	sio.i a2, 38, t4

	lio.i t1, a1, 40
	lio.i t2, a1, 42
	lio.i t3, a1, 44
	lio.i t4, a1, 46

	sio.i a2, 40, t1
	sio.i a2, 42, t2
	sio.i a2, 44, t3
	sio.i a2, 46, t4

	lio.i t1, a1, 48
	lio.i t2, a1, 50
	lio.i t3, a1, 52
	lio.i t4, a1, 54

	sio.i a2, 48, t1
	sio.i a2, 50, t2
	sio.i a2, 52, t3
	sio.i a2, 54, t4

	lio.i t1, a1, 56
	lio.i t2, a1, 58
	lio.i t3, a1, 60
	lio.i t4, a1, 62

	sio.i a2, 56, t1
	sio.i a2, 58, t2
	sio.i a2, 60, t3
	sio.i a2, 62, t4

	addi a2, a2, 64
	addi a1, a1, 64
	subi t0, t0, 1
	bne t0, zero, .copy16_by_64

.copy16_by_64done:
	andi t0, a0, 63

	b .copy_last_bytes

.aligned32:
	rshi t0, a0, 6 ;do 64 bytes each loop

	beq t0, zero, .copy32_by_64done

.copy32_by_64:
	l.l   t1, a1, zero
	lio.l t2, a1, 4
	lio.l t3, a1, 8
	lio.l t4, a1, 12

	s.l   a2, zero, t1
	sio.l a2, 4,    t2
	sio.l a2, 8,    t3
	sio.l a2, 12,   t4

	lio.l t1, a1, 16
	lio.l t2, a1, 20
	lio.l t3, a1, 24
	lio.l t4, a1, 28

	sio.l a2, 16,  t1
	sio.l a2, 20, t2
	sio.l a2, 24, t3
	sio.l a2, 28, t4

	lio.l t1, a1, 32
	lio.l t2, a1, 36
	lio.l t3, a1, 40
	lio.l t4, a1, 44

	sio.l a2, 32, t1
	sio.l a2, 36, t2
	sio.l a2, 40, t3
	sio.l a2, 44, t4

	lio.l t1, a1, 48
	lio.l t2, a1, 52
	lio.l t3, a1, 56
	lio.l t4, a1, 60

	sio.l a2, 48, t1
	sio.l a2, 52, t2
	sio.l a2, 56, t3
	sio.l a2, 60, t4

	addi a2, a2, 64
	addi a1, a1, 64
	subi t0, t0, 1
	bne t0, zero, .copy32_by_64

.copy32_by_64done:
	andi t0, a0, 63

	b .copy_last_bytes

.unaligned:
	rshi t0, a0, 5 ;do 32 bytes each loop

	beq t0, zero, .copy8_by_32done

.copy8_by_32:
	l.b   t1, a1, zero
	lio.b t2, a1, 1
	lio.b t3, a1, 2
	lio.b t4, a1, 3

	s.b   a2, zero, t1
	sio.b a2, 1,    t2
	sio.b a2, 2,    t3
	sio.b a2, 3,    t4

	lio.b t1, a1, 4
	lio.b t2, a1, 5
	lio.b t3, a1, 6
	lio.b t4, a1, 7

	sio.b a2, 4,  t1
	sio.b a2, 5,  t2
	sio.b a2, 6,  t3
	sio.b a2, 7,  t4

	lio.b t1, a1, 8
	lio.b t2, a1, 9
	lio.b t3, a1, 10
	lio.b t4, a1, 11

	sio.b a2, 8,  t1
	sio.b a2, 9,  t2
	sio.b a2, 10, t3
	sio.b a2, 11, t4

	lio.b t1, a1, 12
	lio.b t2, a1, 13
	lio.b t3, a1, 14
	lio.b t4, a1, 15

	sio.b a2, 12, t1
	sio.b a2, 13, t2
	sio.b a2, 14, t3
	sio.b a2, 15, t4

	lio.b t1, a1, 16
	lio.b t2, a1, 17
	lio.b t3, a1, 18
	lio.b t4, a1, 19

	sio.b a2, 16, t1
	sio.b a2, 17, t2
	sio.b a2, 18, t3
	sio.b a2, 19, t4

	lio.b t1, a1, 20
	lio.b t2, a1, 21
	lio.b t3, a1, 22
	lio.b t4, a1, 23

	sio.b a2, 20, t1
	sio.b a2, 21, t2
	sio.b a2, 22, t3
	sio.b a2, 23, t4

	lio.b t1, a1, 24
	lio.b t2, a1, 25
	lio.b t3, a1, 26
	lio.b t4, a1, 27

	sio.b a2, 24, t1
	sio.b a2, 25, t2
	sio.b a2, 26, t3
	sio.b a2, 27, t4

	lio.b t1, a1, 28
	lio.b t2, a1, 29
	lio.b t3, a1, 30
	lio.b t4, a1, 31

	sio.b a2, 28, t1
	sio.b a2, 29, t2
	sio.b a2, 30, t3
	sio.b a2, 31, t4

	addi a2, a2, 32
	addi a1, a1, 32
	subi t0, t0, 1
	bne t0, zero, .copy8_by_32

.copy8_by_32done:
	andi t0, a0, 31 ;do 1 byte each loop

.copy_last_bytes:
	beq t0, zero, .done

.b1:
	l.b t1, a1, zero
	s.b a2, zero, t1

	addi a2, a2, 1
	addi a1, a1, 1
	subi t0, t0, 1
	bne t0, zero, .b1

.done:
	ret