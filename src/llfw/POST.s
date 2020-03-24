.extern LLFWSerialPuts
.extern LLFWError

LLFWPBV === 0x2
LLFWCPUV === 0x2

;r0 - RAM count
LLFWPOST:
.global LLFWPOST
	push r0
	li r0, LLFWPOSTString
	call LLFWSerialPuts
	pop r0

	cmpi r0, 0x40000 ;if not at least 256KB of RAM,
	bl .noRAM ;error

	lri.l r0, 0xF8000800 ;check platformboard version
	andi r0, r0, 0xFFFF0000 ;mask off major
	rshi r0, r0, 16 ;get major
	cmpi r0, LLFWPBV ;if not compatible,
	bne .badPB ;bad board.

	cpu ;get cpuid in r0
	andi r0, r0, 0x7FFF0000 ;mask off experimental bit and minor version
	rshi r0, r0, 16 ;get major
	cmpi r0, LLFWCPUV ;if not compatible,
	bne .badCPU ;bad cpu.

	li r0, LLFWPOSTPassed
	call LLFWSerialPuts

	ret

.noRAM:
	iori r1, r0, 0x01000000
	li r0, LLFWPOSTNoRAM
	b LLFWError

.badPB:
	mov r1, r0
	li r0, LLFWBadPBString
	iori r1, r1, 0x03000000
	call LLFWError

.badCPU:
	mov r1, r0
	li r0, LLFWBadCPUString
	iori r1, r1, 0x04000000
	call LLFWError

LLFWFault:
.global LLFWFault
	li r1, 0x02000000
	ior r1, r1, r0
	li r0, LLFWFaultString
	b LLFWError

LLFWBadCPUString:
	.ds Incompatible CPU type!
	.db 0xA, 0x0

LLFWBadPBString:
	.ds Incompatible motherboard!
	.db 0xA, 0x0

LLFWFaultString:
	.ds Unexpected fault!
	.db 0xA, 0x0

LLFWPOSTString:
	.ds Basic self-test...
	.db 0xA, 0x0

LLFWPOSTPassed:
	.ds Self-test passed.
	.db 0xA, 0x0

LLFWPOSTNoRAM:
	.ds Insufficient RAM to run this firmware, at least 256KB must be
	.db 0xA
	.ds installed in slot 0.
	.db 0xA, 0x0