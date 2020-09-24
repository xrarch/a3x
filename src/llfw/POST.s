.extern Puts

.extern Error

.extern Putn

.extern Reset

PBVersion === 0xF8000800

ExpectedPBVersion === 0x2
ExpectedCPUVersion === 0x4

;a0: RAM size
POST:
.global POST
	push lr
	push s0

	mov s0, a0

	la a0, POSTString
	jal Puts

	lui t0, 0x40000
	blt s0, t0, .noRAM

	la t0, PBVersion
	l.l t0, t0, zero
	rshi t0, t0, 16
	bnei t0, ExpectedPBVersion, .badPB

	rshi t0, cpuid, 16
	andi.i t0, 0x7FFF
	bnei t0, ExpectedCPUVersion, .badCPU

	la a0, POSTPassed
	jal Puts

	pop s0
	pop lr
	ret

.noRAM:
	lui a1, 0x01000000
	rshi s0, s0, 12
	or a1, a1, s0
	la a0, POSTNoRAM
	jal Error
	j Reset

.badPB:
	lui a1, 0x03000000
	or a1, a1, s0
	la a0, BadPBString
	jal Error
	j Reset

.badCPU:
	lui a1, 0x04000000
	or a1, a1, s0
	la a0, BadCPUString
	jal Error
	j Reset

.section data

BadCPUString:
	.ds Incompatible CPU type!
	.db 0xA, 0x0

BadPBString:
	.ds Incompatible motherboard!
	.db 0xA, 0x0

POSTString:
	.ds Basic self-test...
	.db 0xA, 0x0

POSTPassed:
	.ds Self-test passed.
	.db 0xA, 0x0

POSTNoRAM:
	.ds Insufficient RAM to run this firmware, at least 256KB must be
	.db 0xA
	.ds installed in slot 0.
	.db 0xA, 0x0