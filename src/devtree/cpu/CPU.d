#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* platform independent cpu interface, antecedent standard *)

var SCPUNode 0

procedure GCPUDefault (* -- defaultnode *)
	"cpu-dev" NVRAMGetVar dup if (0 ==)
		drop PlatformCPUPath@ "cpu-dev" NVRAMSetVar
		PlatformCPUPath@
	end

	auto dn
	DevTreeWalk dn!

	if (dn@ 0 ==)
		"cpu-dev is phony, trying platform default\n" Printf

		PlatformCPUPath@ "cpu-dev" NVRAMSetVar
		PlatformCPUPath@ DevTreeWalk dn!
	end

	dn@
end

procedure BuildGCPU (* -- *)
	GCPUDefault SCPUNode!

	if (SCPUNode@ 0 ~=)
		SCPUNode@ DeviceClone
			"cpu" DSetName
		DeviceExit
	end
end