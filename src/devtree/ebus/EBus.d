const EBusSlotsStart 0xC0000000
const EBusSlots 7
const EBusSlotSpace 0x8000000
const EBusBoardMagic 0x0C007CA1

#include "devtree/ebus/dma/DMA.d"
#include "devtree/ebus/platformboard/PBoard.d"
#include "devtree/ebus/kinnow3/Kinnow3.d"

procedure BuildEBus (* -- *)
	DeviceNew
		"ebus" DSetName

		"\n\t\tSetting up DMA... " Puts
		BuildDMA 
		if (1 ==)
			"complete!"
		end
		else
			"aborted!"
		end
		Puts
		"\n\t\tSetting up PBoard... " Puts
		BuildPBoard
		if (1 ==)
			"complete!\n\t\t" Puts
		end
		"Setting up Kinnow3... " Puts
		BuildKinnow3
		"complete!\n\t" Puts
	DeviceExit
end

(* find first board of id *)
procedure EBusFindFirstBoard (* id -- slot *)
	auto id
	id!

	auto i
	0 i!

	while (i@ EBusSlots <)
		auto bp
		i@ EBusSlotSpace * EBusSlotsStart + bp!

		if (bp@@ EBusBoardMagic ==)
			if (bp@ 4 + @ id@ ==)
				i@ return
			end
		end

		1 i@ + i!
	end

	ERR return
end

procedure EBusSlotInterruptRegister (* handler slot -- *)
	0x98 + InterruptRegister
end
