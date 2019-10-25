#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* platform independent memory interface, antecedent standard *)

var SMemoryNode 0

procedure GMemoryDefault (* -- defaultnode *)
	"memory-dev" NVRAMGetVar dup if (0 ==)
		drop PlatformMemoryPath@ "memory-dev" NVRAMSetVar
		PlatformMemoryPath@
	end

	auto dn
	DevTreeWalk dn!

	if (dn@ 0 ==)
		"memory-dev is phony, trying platform default\n" Printf

		PlatformMemoryPath@ "memory-dev" NVRAMSetVar
		PlatformMemoryPath@ DevTreeWalk dn!
	end

	dn@
end

procedure BuildGMemory (* -- *)
	GMemoryDefault SMemoryNode!

	if (SMemoryNode@ 0 ~=)
		SMemoryNode@ DeviceClone
			"memory" DSetName
		DeviceExit
	end
end