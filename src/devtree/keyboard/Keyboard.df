#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* platform independent keyboard interface, antecedent standard *)

var SKbdNode 0

procedure GKbdDefault { -- dn }
	"kbd-dev" NVRAMGetVar dup if (0 ==)
		drop PlatformKeyboardPath@ "kbd-dev" NVRAMSetVar
		PlatformKeyboardPath@
	end

	DevTreeWalk dn!

	if (dn@ 0 ==)
		"kbd-dev is phony, trying platform default\n" Printf

		PlatformKeyboardPath@ "kbd-dev" NVRAMSetVar
		PlatformKeyboardPath@ DevTreeWalk dn!
	end
end

procedure BuildGKeyboard (* -- *)
	GKbdDefault SKbdNode!

	if (SKbdNode@ 0 ~=)
		SKbdNode@ DeviceClone
			"keyboard" DSetName
		DeviceExit
	end
end