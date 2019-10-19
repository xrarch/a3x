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

OpADD:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	add r4, r10, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpSUB:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	sub r4, r10, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpMUL:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	mul r4, r10, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpDIV:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	div r4, r10, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpMOD:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	mod r4, r10, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpDROP:
	subi r1, r1, 4
	ret

OpEQ:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	cmp r10, r4
	be .eq
	sri.l r1, 0
	addi r1, r1, 4
	ret

.eq:
	sri.l r1, 1
	addi r1, r1, 4
	ret

OpNEQ:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	cmp r10, r4
	bne .neq
	sri.l r1, 0
	addi r1, r1, 4
	ret

.neq:
	sri.l r1, 1
	addi r1, r1, 4
	ret

OpGT:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	cmp r10, r4
	bg .gt
	sri.l r1, 0
	addi r1, r1, 4
	ret

.gt:
	sri.l r1, 1
	addi r1, r1, 4
	ret

OpLT:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	cmp r10, r4
	bl .lt
	sri.l r1, 0
	addi r1, r1, 4
	ret

.lt:
	sri.l r1, 1
	addi r1, r1, 4
	ret

OpB:
	subi r1, r1, 4
	lrr.l r0, r1
	add r0, r0, r7
	ret

OpBT:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	cmpi r10, 1
	be .j
	ret

.j:
	mov r0, r4
	add r0, r0, r7
	ret

OpBF:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	cmpi r10, 0
	be .j
	ret

.j:
	mov r0, r4
	add r0, r0, r7
	ret

OpLOAD:
	subi r1, r1, 4
	lrr.l r4, r1
	lrr.l r4, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpSTORE:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	srr.l r10, r4
	ret

OpSWAP:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	srr.l r1, r4
	addi r1, r1, 4
	srr.l r1, r10
	addi r1, r1, 4
	ret

OpCALL:
	srr.l r2, r0
	addi r2, r2, 4
	subi r1, r1, 4
	lrr.l r0, r1
	add r0, r0, r7
	ret

OpCALLT:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	cmpi r10, 1
	be .j
	ret

.j:
	srr.l r2, r0
	addi r2, r2, 4
	mov r0, r4
	add r0, r0, r7
	ret

OpCALLF:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	cmpi r10, 0
	be .j
	ret

.j:
	srr.l r2, r0
	addi r2, r2, 4
	mov r0, r4
	add r0, r0, r7
	ret

OpRET:
	cmp r2, r6
	be .finished

	subi r2, r2, 4
	lrr.l r0, r2
	ret

.finished:
	li r0, 1
	call FastReturn

OpRETT:
	subi r1, r1, 4
	lrr.l r4, r1
	cmpi r4, 1
	be .ret
	ret

.ret:
	cmp r2, r6
	be .finished

	subi r2, r2, 4
	lrr.l r0, r2
	ret

.finished:
	li r0, 1
	call FastReturn

OpRETF:
	subi r1, r1, 4
	lrr.l r4, r1
	cmpi r4, 0
	be .ret
	ret

.ret:
	cmp r2, r6
	be .finished

	subi r2, r2, 4
	lrr.l r0, r2
	ret

.finished:
	li r0, 1
	call FastReturn

OpPUSHD:
	subi r1, r1, 4
	lrr.l r4, r1
	pushv r5, r4
	ret

OpPOPD:
	popv r5, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpXOR:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	eor r4, r10, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpOR:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	ior r4, r10, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpNOT:
	subi r1, r1, 4
	lrr.l r4, r1
	not r4, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

OpAND:
	subi r1, r1, 4
	lrr.l r4, r1
	subi r1, r1, 4
	lrr.l r10, r1
	and r4, r10, r4
	srr.l r1, r4
	addi r1, r1, 4
	ret

Unimplemented:
	ret


PECBiggestOp === 0x20

PECOpTable:
	.dl OpNOP ;0
	.dl OpPUSH ;1
	.dl OpADD ;2
	.dl OpSUB ;3
	.dl OpMUL ;4
	.dl OpDIV ;5
	.dl OpMOD ;6
	.dl OpDROP ;7
	.dl OpEQ ;8
	.dl OpNEQ ;9
	.dl OpGT ;A
	.dl OpLT ;B
	.dl OpB ;C
	.dl OpBT ;D
	.dl OpBF ;E
	.dl OpLOAD ;F
	.dl OpSTORE ;10
	.dl OpSWAP ;11
	.dl OpCALL ;12
	.dl OpCALLT ;13
	.dl OpCALLF ;14
	.dl OpRET ;15
	.dl OpRETT ;16
	.dl OpRETF ;17
	.dl OpPOPD ;18
	.dl OpPUSHD ;19
	.dl OpNCALL ;1A
	.dl OpBASE ;1B
	.dl OpSLOT ;1C
	.dl OpXOR ;1D
	.dl OpOR ;1E
	.dl OpNOT ;1F
	.dl OpAND ;20