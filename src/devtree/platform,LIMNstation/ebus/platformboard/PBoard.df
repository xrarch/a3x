#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

var PBInterruptsVT 0

extern BuildCitron

procedure BuildPBoard (* -- *)
	1024 Calloc PBInterruptsVT!

	pointerof PBInterruptASM 0x7 EBusSlotInterruptRegister

	DeviceNew
		"platformboard" DSetName

		PBInfo@ "version" DAddProperty

		BuildCitron
	DeviceExit
end

procedure PBInterrupt (* -- *)
	auto handler
	PBInfoIRQ@ 4 * PBInterruptsVT@ + @ handler!

	if (handler@ 0 ~=)
		handler@ Call
	end
end

asm "

PBInterruptASM:
	pusha

	call PBInterrupt

	popa
	iret

"

procedure PBInterruptRegister (* handler num -- *)
	4 * PBInterruptsVT@ + !
end