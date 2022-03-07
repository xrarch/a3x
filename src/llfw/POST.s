.extern Puts

.extern Error

.extern Putn

.extern Reset

.define PBVersion 0xF8000800

.define ExpectedPBVersion  0x3
.define ExpectedCPUVersion 0x6

.section text

POST:
.global POST
	subi sp, sp, 8
	mov  long [sp], lr
	mov  long [sp + 4], s0

	la   t0, PBVersion
	mov  t0, long [t0]
	rshi t0, t0, 16
	subi t1, t0, ExpectedPBVersion
	bne  t1, .badPB

	mfcr t0, cpuid
	rshi t0, t0, 16
	andi t0, t0, 0x7FFF
	subi t1, t0, ExpectedCPUVersion
	bne  t1, .badCPU

	la   a0, POSTPassed
	jal  Puts

	mov  s0, long [sp + 4]
	mov  lr, long [sp]
	addi sp, sp, 8

	ret

.badPB:
	lui  a1, zero, 0x03000000
	or   a1, a1, s0
	la   a0, BadPBString
	jal  Error
	j    Reset

.badCPU:
	lui  a1, zero, 0x04000000
	or   a1, a1, s0
	la   a0, BadCPUString
	jal  Error
	j    Reset

.section data

BadCPUString:
	.ds "Incompatible CPU type!\n\0"

BadPBString:
	.ds "Incompatible motherboard!\n\0"

POSTString:
	.ds "Basic self-test...\n\0"

POSTPassed:
	.ds "Self-test passed.\n\0"