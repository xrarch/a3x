; r0 as PC
; r1 as data base
; r2 as RSP
; r3 as current opcode
; r4 as scratch
; r5 as DF stack
; r6 as ReturnStack base
; r7 as auc code base
; r8 as slotspace base
; r9 as dest
; r10 as src1
; r11 as src2
; r12 as imm24
; r13 as imm16
; r14-r30 as scratch

.extern AUCData
.extern AUCReturnStack

StatusInvalidOp === 0
StatusOk === 1
StatusBadNC === 2

AUCRegisters:
	.bytes 112 0
AUCRF:
	.dl 0
AUCRData:
	.dl 0
AUCRCode:
	.dl 0
AUCRSlot:
	.dl 0

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
AUCInterpret:
.global AUCInterpret
	popv r5, r7
	popv r5, r0
	popv r5, r8
	pusha
	sir.l FastReturnSP, sp

	lri.l r1, AUCData
	lri.l r2, AUCReturnStack
	mov r6, r2

	sir.l AUCRData, r1
	sir.l AUCRCode, r7
	sir.l AUCRSlot, r8

.loop:
	lrr.b r3, r0
	cmpi r3, AUCBiggestOp
	bg .invalid

	muli r4, r3, 4
	addi r4, r4, AUCOpTable
	lrr.l r4, r4

	addi r0, r0, 1
	lrr.b r9, r0
	addi r0, r0, 1
	lrr.b r10, r0
	lrr.i r13, r0
	addi r0, r0, 1
	lrr.b r11, r0
	lshi r12, r13, 8
	ior r12, r12, r9

	addi r0, r0, 1

	call .callpocket

	b .loop

.callpocket:
	br r4

.invalid:
	li r0, StatusInvalidOp
	call FastReturn

OpNOP:
	ret

.extern AUCNativeCall

OpLI:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	srr.l r9, r13
	ret

OpLUI:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	lrr.l r14, r9
	lshi r13, r13, 16
	ior r14, r14, r13
	srr.l r9, r14
	ret

OpSB:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	lrr.l r9, r9
	muli r10, r10, 4
	addi r10, r10, AUCRegisters
	lrr.l r10, r10
	srr.b r9, r10
	ret

OpSI:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	lrr.l r9, r9
	muli r10, r10, 4
	addi r10, r10, AUCRegisters
	lrr.l r10, r10
	srr.i r9, r10
	ret

OpSL:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	lrr.l r9, r9
	muli r10, r10, 4
	addi r10, r10, AUCRegisters
	lrr.l r10, r10
	srr.l r9, r10
	ret

OpLB:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	muli r10, r10, 4
	addi r10, r10, AUCRegisters
	lrr.l r10, r10
	srr.b r9, r10
	ret

OpLMI:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	muli r10, r10, 4
	addi r10, r10, AUCRegisters
	lrr.l r10, r10
	srr.i r9, r10
	ret

OpLL:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	muli r10, r10, 4
	addi r10, r10, AUCRegisters
	lrr.l r10, r10
	lrr.l r10, r10
	srr.l r9, r10
	ret

OpADD:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	add r10, r10, r11
	srr.l r9, r10
	ret

OpSUB:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	sub r10, r10, r11
	srr.l r9, r10
	ret

OpMUL:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	mul r10, r10, r11
	srr.l r9, r10
	ret

OpDIV:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	div r10, r10, r11
	srr.l r9, r10
	ret

OpNOT:
	muli r9, r9, 4
	muli r10, r10, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	lrr.l r10, r10
	not r10, r10
	srr.l r9, r10
	ret

OpOR:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	ior r10, r10, r11
	srr.l r9, r10
	ret

OpAND:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	and r10, r10, r11
	srr.l r9, r10
	ret

OpXOR:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	eor r10, r10, r11
	srr.l r9, r10
	ret

OpLSH:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	lsh r10, r10, r11
	srr.l r9, r10
	ret

OpRSH:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	rsh r10, r10, r11
	srr.l r9, r10
	ret

OpBSET:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	bset r10, r10, r11
	srr.l r9, r10
	ret

OpBCLR:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	bclr r10, r10, r11
	srr.l r9, r10
	ret

OpBT:
	lri.l r14, AUCRF
	cmpi r14, 0
	be .out

	mov r0, r12
	add r0, r0, r7

.out:
	ret

OpBF:
	lri.l r14, AUCRF
	cmpi r14, 0
	bne .out

	mov r0, r12
	add r0, r0, r7

.out:
	ret

OpBR:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	lrr.l r0, r9
	add r0, r0, r7
	ret

OpCALL:
	srr.l r2, r0
	addi r2, r2, 4
	mov r0, r12
	add r0, r0, r7
	ret

OpCALLR:
	srr.l r2, r0
	addi r2, r2, 4
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	lrr.l r0, r9
	add r0, r0, r7
	ret

OpG:
	muli r9, r9, 4
	muli r10, r10, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	lrr.l r9, r9
	lrr.l r10, r10
	cmp r9, r10
	bg .g
	b .le

.g:
	sii.l AUCRF, 1
	b .out

.le:
	sii.l AUCRF, 0

.out:
	ret

OpL:
	muli r9, r9, 4
	muli r10, r10, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	lrr.l r9, r9
	lrr.l r10, r10
	cmp r9, r10
	bl .g
	b .le

.g:
	sii.l AUCRF, 1
	b .out

.le:
	sii.l AUCRF, 0

.out:
	ret

OpE:
	muli r9, r9, 4
	muli r10, r10, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	lrr.l r9, r9
	lrr.l r10, r10
	cmp r9, r10
	be .g
	b .le

.g:
	sii.l AUCRF, 1
	b .out

.le:
	sii.l AUCRF, 0

.out:
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

OpA3X:
	pusha
	pushv r5, r12
	call AUCNativeCall
	popv r5, r14
	cmpi r14, 1
	bne .invalid
	popa
	ret

.invalid:
	li r0, StatusBadNC
	call FastReturn

OpPUSH:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	lrr.l r9, r9
	pushv r5, r9
	ret

OpPOP:
	popv r5, r14
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	srr.l r9, r14
	ret

OpDROP:
	popv r5, r14
	ret

OpSWAP:
	popv r5, r14
	popv r5, r15
	pushv r5, r14
	pushv r5, r15
	ret

OpGS:
	muli r9, r9, 4
	muli r10, r10, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	lrr.l r9, r9
	lrr.l r10, r10
	cmps r9, r10
	bg .g
	b .le

.g:
	sii.l AUCRF, 1
	b .out

.le:
	sii.l AUCRF, 0

.out:
	ret

OpLS:
	muli r9, r9, 4
	muli r10, r10, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	lrr.l r9, r9
	lrr.l r10, r10
	cmps r9, r10
	bl .g
	b .le

.g:
	sii.l AUCRF, 1
	b .out

.le:
	sii.l AUCRF, 0

.out:
	ret

OpMOD:
	muli r9, r9, 4
	muli r10, r10, 4
	muli r11, r11, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	addi r11, r11, AUCRegisters
	lrr.l r10, r10
	lrr.l r11, r11
	mod r10, r10, r11
	srr.l r9, r10
	ret

OpDUP:
	lrr.l r14, r5
	pushv r5, r14
	ret

OpB:
	mov r0, r12
	add r0, r0, r7
	ret

OpNE:
	muli r9, r9, 4
	muli r10, r10, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	lrr.l r9, r9
	lrr.l r10, r10
	cmp r9, r10
	bne .g
	b .le

.g:
	sii.l AUCRF, 1
	b .out

.le:
	sii.l AUCRF, 0

.out:
	ret

OpRPUSH:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	lrr.l r9, r9
	srr.l r2, r9
	addi r2, r2, 4
	ret

OpRPOP:
	muli r9, r9, 4
	addi r9, r9, AUCRegisters
	subi r2, r2, 4
	lrr.l r14, r2
	srr.l r9, r14
	ret

OpPUSH24:
	pushv r5, r12
	ret

OpMOV:
	muli r9, r9, 4
	muli r10, r10, 4
	addi r9, r9, AUCRegisters
	addi r10, r10, AUCRegisters
	lrr.l r10, r10
	srr.l r9, r10
	ret

Unimplemented:
	ret


AUCBiggestOp === 0x2C

AUCOpTable:
	.dl OpNOP ;0
	.dl OpLI ;1
	.dl OpLUI ;2
	.dl OpSB ;3
	.dl OpSI ;4
	.dl OpSL ;5
	.dl OpLB ;6
	.dl OpLMI ;7
	.dl OpLL ;8
	.dl OpADD ;9
	.dl OpSUB ;A
	.dl OpMUL ;B
	.dl OpDIV ;C
	.dl OpNOT ;D
	.dl OpOR ;E
	.dl OpAND ;F
	.dl OpXOR ;10
	.dl OpLSH ;11
	.dl OpRSH ;12
	.dl OpBSET ;13
	.dl OpBCLR ;14
	.dl OpBT ;15
	.dl OpBF ;16
	.dl OpBR ;17
	.dl OpCALL ;18
	.dl OpCALLR ;19
	.dl OpG ;1A
	.dl OpL ;1B
	.dl OpE ;1C
	.dl OpRET ;1D
	.dl OpA3X ;1E
	.dl OpPUSH ;1F
	.dl OpPOP ;20
	.dl OpDROP ;21
	.dl OpSWAP ;22
	.dl OpGS ;23
	.dl OpLS ;24
	.dl OpMOD ;25
	.dl OpDUP ;26
	.dl OpB ;27
	.dl OpNE ;28
	.dl OpRPUSH ;29
	.dl OpRPOP ;2A
	.dl OpPUSH24 ;2B
	.dl OpMOV ;2C