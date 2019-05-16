(* ebus dma controller driver *)

const DMARegisterSource 0x38000000
const DMARegisterDest 0x38000004
const DMARegisterSInc 0x38000008
const DMARegisterDInc 0x3800000C
const DMARegisterCount 0x38000010
const DMARegisterMode 0x38000014
const DMARegisterStatus 0x38000018

procedure BuildDMA (* -- *)
	DeviceNew
		"dma" DSetName

		pointerof DMATransfer "transfer" DAddMethod
	DeviceExit

	DMAWaitUnbusy
	0 DMARegisterStatus!
end

procedure DMAWaitUnbusy (* -- *)
	while (DMARegisterStatus@ 1 &) end
end

procedure DMADoOperation (* -- *)
	DMARegisterStatus@ 1 | DMARegisterStatus!
end

procedure DMATransfer (* src dest srcinc decinc count mode -- *)
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