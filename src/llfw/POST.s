.extern Puts

.extern Error

.extern Putn

.extern Reset

PBVersion === 0xF8000800

ExpectedPBVersion === 0x2
ExpectedCPUVersion === 0x4

POST:
.global POST
	push lr

	push r1
	la r1, POSTString
	jal Puts
	pop r1

	lui r2, 0x40000
	blt r1, r2, .noRAM

	la r1, POSTPassed
	jal Puts

	la r1, PBVersion
	l.l r1, r1, zero
	rshi r1, r1, 16
	bnei r1, ExpectedPBVersion, .badPB

	rshi r1, cpuid, 16
	andi.i r1, 0x7FFF
	bnei r1, ExpectedCPUVersion, .badCPU

	pop lr
	ret

.noRAM:
	lui r2, 0x01000000
	or r2, r2, r1
	la r1, POSTNoRAM
	jal Error
	j Reset

.badPB:
	lui r2, 0x03000000
	or r2, r2, r1
	la r1, BadPBString
	jal Error
	j Reset

.badCPU:
	lui r2, 0x04000000
	or r2, r2, r1
	la r1, BadCPUString
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