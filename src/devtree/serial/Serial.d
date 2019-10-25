#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* platform independent serial interface, antecedent standard *)

var SSerialNode 0

procedure GSerialDefault { -- defaultnode }
	"serial-dev" NVRAMGetVar dup if (0 ==)
		drop PlatformSerialPath@ "serial-dev" NVRAMSetVar
		PlatformSerialPath@
	end

	DevTreeWalk defaultnode!

	if (defaultnode@ 0 ==)
		"serial-dev is phony, trying platform default\n" Printf

		PlatformSerialPath@ "serial-dev" NVRAMSetVar
		PlatformSerialPath@ DevTreeWalk defaultnode!
	end
end

procedure BuildGSerial (* -- *)
	GSerialDefault SSerialNode!

	if (SSerialNode@ 0 ~=)
		SSerialNode@ DeviceClone
			"serial" DSetName
		DeviceExit
	end
end