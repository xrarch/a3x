; r0 as PC
; r1 as SP
; r2 as RSP
; r3 as current byte
; r4 as scratch
; r5 as DF stack
; r6 as ReturnStack base
; r7 as PEC code base
; r8 as slotspace base
; r10-r30 as scratch

.extern PECStack
.extern PECReturnStack

StatusInvalidOp === 0
StatusOk === 1
StatusBadNC === 2

FastReturnSP:
	.dl 0

TRV:
	.dl 0

;r0 - return value
FastReturn:
	sir.l TRV, r0

	lri.l r0, FastReturnSP
	ssp r0
	popa
	
	lri.l r0, TRV
	pushv r5, r0
	ret

; slotspace func base -- ok
PECInterpret:
.global PECInterpret
	popv r5, r7
	popv r5, r0
	popv r5, r8
	pusha
	sir.l FastReturnSP, sp

	lri.l r1, PECStack
	lri.l r2, PECReturnStack
	mov r6, r2

.loop:
	lrr.b r3, r0
	cmpi r3, PECBiggestOp
	bg .invalid

	muli r4, r3, 4
	addi r4, r4, PECOpTable
	lrr.l r4, r4

	addi r0, r0, 1

	call .callpocket

	b .loop

.callpocket:
	br r4

.invalid:
	li r0, StatusInvalidOp
	call FastReturn

UStr:
	.ds Unimplemented op
	.db 0xA, 0x0

OpNOP:
	ret

OpPUSH:
	lrr.l r4, r0
	addi r0, r0, 4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpPUSHD:
	subi r1, r1, 4
	lrr.l r4, r1
	pushv r5, r4
	ret

.extern PECNativeCall
OpNCALL:
	lrr.l r4, r0
	addi r0, r0, 4
	pusha
	pushv r5, r4
	call PECNativeCall
	popv r5, r4
	cmpi r4, 1
	bne .invalid
	popa
	ret

.invalid:
	li r0, StatusBadNC
	call FastReturn

OpRET:
	cmp r2, r6
	be .finished

	subi r2, r2, 4
	lrr.l r0, r2
	ret

.finished:
	li r0, 1
	call FastReturn

OpBASE:
	subi r1, r1, 4
	lrr.l r4, r1
	add r4, r4, r7
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpSLOT:
	subi r1, r1, 4
	lrr.l r4, r1
	add r4, r4, r8
	srr.l r1, r4
	addi r1, r1, 4
	ret

Unimplemented:
	ret


PECBiggestOp === 0x1C

PECOpTable:
	.dl OpNOP ;0
	.dl OpPUSH ;1
	.dl Unimplemented ;2
	.dl Unimplemented ;3
	.dl Unimplemented ;4
	.dl Unimplemented ;5
	.dl Unimplemented ;6
	.dl Unimplemented ;7
	.dl Unimplemented ;8
	.dl Unimplemented ;9
	.dl Unimplemented ;A
	.dl Unimplemented ;B
	.dl Unimplemented ;C
	.dl Unimplemented ;D
	.dl Unimplemented ;E
	.dl Unimplemented ;F
	.dl Unimplemented ;10
	.dl Unimplemented ;11
	.dl Unimplemented ;12
	.dl Unimplemented ;13
	.dl Unimplemented ;14
	.dl OpRET ;15
	.dl Unimplemented ;16
	.dl Unimplemented ;17
	.dl Unimplemented ;18
	.dl OpPUSHD ;19
	.dl OpNCALL ;1A
	.dl OpBASE ;1B
	.dl OpSLOT ;1C