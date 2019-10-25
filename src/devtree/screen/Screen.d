#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* platform independent screen interface, antecedent standard *)

var SScreenNode 0

procedure GScreenDefault { -- dn }
	"screen-dev" NVRAMGetVar dup if (0 ==)
		drop PlatformScreenPath@ "screen-dev" NVRAMSetVar
		PlatformScreenPath@
	end

	DevTreeWalk dn!

	if (dn@ 0 ==)
		"screen-dev is phony, trying platform default\n" Printf

		PlatformScreenPath@ "screen-dev" NVRAMSetVar
		PlatformScreenPath@ DevTreeWalk dn!
	end
end

procedure BuildGScreen (* -- *)
	GScreenDefault SScreenNode!

	if (SScreenNode@ 0 ~=)
		SScreenNode@ DeviceClone
			"screen" DSetName
		DeviceExit

		if ("screen-bg" NVRAMGetVar 0 ==)
			PlatformDefaultScreenBG@ "screen-bg" NVRAMSetVar
		end
		if ("screen-fg" NVRAMGetVar 0 ==)
			PlatformDefaultScreenFG@ "screen-fg" NVRAMSetVar
		end
	end
end