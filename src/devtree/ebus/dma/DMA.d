(* ebus dma controller driver *)

const DMARegisterSource 0x38000000
const DMARegisterDest 0x38000004
const DMARegisterSInc 0x38000008
const DMARegisterDInc 0x3800000C
const DMARegisterCount 0x38000010
const DMARegisterMode 0x38000014
const DMARegisterStatus 0x38000018

procedure BuildDMA (* -- *)
	"\n\t\t\tChecking for DMA presence..." Puts
	if (DMARegisterSource@ -1 ==)
		"No DMA!\n\t\t" Puts
		0
	end
	else
		"\n\t\t\tBuilding device... " Puts
		DeviceNew
			"dma" DSetName

			pointerof DMATransfer "transfer" DAddMethod
		DeviceExit
		"complete!\n\t\t\tWaiting for DMA to not be busy..." Puts

		DMAWaitUnbusy
		"complete!\n\t\t"
		0 DMARegisterStatus!
		1
	end
end

procedure DMAWaitUnbusy (* -- *)
	while (DMARegisterStatus@ 1 &) end
end

procedure DMADoOperation (* -- *)
	DMARegisterStatus@ 1 | DMARegisterStatus!
end

procedure DMATransfer (* src dest srcinc destinc count mode -- *)
	auto mode
	mode!

	auto count
	count!

	auto destinc
	destinc!

	auto srcinc
	srcinc!

	auto dest
	dest!

	auto src
	src!

	src@ DMARegisterSource!
	dest@ DMARegisterDest!
	srcinc@ DMARegisterSInc!
	destinc@ DMARegisterDInc!
	count@ DMARegisterCount!
	mode@ DMARegisterMode!

	DMADoOperation
	DMAWaitUnbusy
end
