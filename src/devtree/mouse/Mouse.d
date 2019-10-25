#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* platform independent mouse interface, antecedent standard *)

var SMouseNode 0

procedure GMouseDefault { -- dn }
	"mouse-dev" NVRAMGetVar dup if (0 ==)
		drop PlatformMousePath@ "mouse-dev" NVRAMSetVar
		PlatformMousePath@
	end

	DevTreeWalk dn!

	if (dn@ 0 ==)
		"mouse-dev is phony, trying platform default\n" Printf

		PlatformMousePath@ "mouse-dev" NVRAMSetVar
		PlatformMousePath@ DevTreeWalk dn!
	end
end

procedure BuildGMouse (* -- *)
	GMouseDefault SMouseNode!

	if (SMouseNode@ 0 ~=)
		SMouseNode@ DeviceClone
			"mouse" DSetName
		DeviceExit
	end
end