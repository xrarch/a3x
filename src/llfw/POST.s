.extern Puts

.extern Error

.extern Putn

.extern Reset

.define PBVersion 0xF8000800

.define ExpectedPBVersion  0x2
.define ExpectedCPUVersion 0x5

.section text

;a0: RAM size
POST:
.global POST
	subi sp, sp, 8
	mov  long [sp], lr
	mov  long [sp + 4], s0

	mov  s0, a0

	la   a0, POSTString
	jal  Puts

	lui  t0, zero, 0x40000
	blt  s0, t0, .noRAM

	la   t0, PBVersion
	mov  t0, long [t0]
	rshi t0, t0, 16
	bnei t0, ExpectedPBVersion, .badPB

	mfcr t0, cpuid
	rshi t0, t0, 16
	andi t0, t0, 0x7FFF
	bnei t0, ExpectedCPUVersion, .badCPU

	la   a0, POSTPassed
	jal  Puts

	mov  s0, long [sp + 4]
	mov  lr, long [sp]
	addi sp, sp, 8

	ret

.noRAM:
	lui  a1, zero, 0x01000000
	rshi s0, s0, 12
	or   a1, a1, s0
	la   a0, POSTNoRAM
	jal  Error
	j    Reset

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

POSTNoRAM:
	.ds "Insufficient RAM to run this firmware, at least 256KB must be\ninstalled in slot 0.\n\0"