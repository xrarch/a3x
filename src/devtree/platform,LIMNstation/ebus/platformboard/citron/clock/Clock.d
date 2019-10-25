#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

const ClockPortCmd 0x20
const ClockPortA 0x21

var ClockStartSec 0
var ClockStartMS 0

procedure BuildCClock (* -- *)
	DeviceNew
		"clock" DSetName

		pointerof ClockUptime "uptime" DAddMethod
		pointerof ClockEpoch "epoch" DAddMethod
		pointerof ClockWait "wait" DAddMethod
	DeviceExit

	ClockEpoch ClockStartMS! ClockStartSec!
end

procedure ClockEpoch { -- sec ms }
	auto rs
	InterruptDisable rs!

	2 ClockPortCmd DCitronCommand
	ClockPortA DCitronInl sec!

	3 ClockPortCmd DCitronCommand
	ClockPortA DCitronInl ms!

	rs@ InterruptRestore
end

procedure ClockUptime { -- ms }
	auto sec
	ClockEpoch ms! sec!

	sec@ ClockStartSec@ - 1000 * ms@ + ms!
end

procedure ClockWait { ms -- }
	auto wu
	ClockUptime ms@ + wu!

	while (ClockUptime wu@ <) end
end