#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* platform independent clock interface, antecedent standard *)

var SClockNode 0

procedure GClockDefault (* -- defaultnode *)
	"clock-dev" NVRAMGetVar dup if (0 ==)
		drop PlatformClockPath@ "clock-dev" NVRAMSetVar
		PlatformClockPath@
	end

	auto dn
	DevTreeWalk dn!

	if (dn@ 0 ==)
		"clock-dev is phony, trying platform default\n" Printf

		PlatformClockPath@ "clock-dev" NVRAMSetVar
		PlatformClockPath@ DevTreeWalk dn!
	end

	dn@
end

procedure BuildGClock (* -- *)
	GClockDefault SClockNode!

	if (SClockNode@ 0 ~=)
		SClockNode@ DeviceClone
			"clock" DSetName
		DeviceExit
	end
end