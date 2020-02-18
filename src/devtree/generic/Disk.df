#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* platform independent disk interface, antecedent standard *)

var SDiskNode 0

procedure GDiskDefault { -- dn }
	"disk-bus-dev" NVRAMGetVar dup if (0 ==)
		drop PlatformDiskBusPath@ "disk-bus-dev" NVRAMSetVar
		PlatformDiskBusPath@
	end

	DevTreeWalk dn!

	if (dn@ 0 ==)
		"disk-bus-dev is phony, trying platform default\n" Printf

		PlatformDiskBusPath@ "disk-bus-dev" NVRAMSetVar
		PlatformDiskBusPath@ DevTreeWalk dn!
	end
end

procedure BuildGDisk (* -- *)
	GDiskDefault SDiskNode!

	if (SDiskNode@ 0 ~=)
		SDiskNode@ DeviceClone
			"disks" DSetName
		DeviceExit
	end
end