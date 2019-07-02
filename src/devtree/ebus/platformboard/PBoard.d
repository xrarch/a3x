const PBBase 0xF8000000
const PBInfo 0xF8000800
const PBInfoIRQ 0xF8000FFC

#include "devtree/ebus/platformboard/citron/Citron.d"

var PBInterruptsVT 0

procedure BuildPBoard (* -- *)
	if (PBBase@ -1 ==)
		"no platformboard present!\n\t\t" Puts
		0
	end
	else
		1024 Calloc PBInterruptsVT!

		pointerof PBInterruptASM 0x7 EBusSlotInterruptRegister

		DeviceNew
			"platformboard" DSetName

			PBInfo@ "version" DAddProperty
			"\n\t\t\tSetting up Citron... " Puts
			BuildCitron
			"complete!\n\t\t" Puts
		DeviceExit
		1
	end
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
