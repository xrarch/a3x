#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* platform independent dma interface, antecedent standard *)

var SDMANode 0

procedure GDMADefault (* -- defaultnode *)
	"dma-dev" NVRAMGetVar dup if (0 ==)
		drop PlatformDMAPath@ "dma-dev" NVRAMSetVar
		PlatformDMAPath@
	end

	auto dn
	DevTreeWalk dn!

	if (dn@ 0 ==)
		"dma-dev is phony, trying platform default\n" Printf

		PlatformDMAPath@ "dma-dev" NVRAMSetVar
		PlatformDMAPath@ DevTreeWalk dn!
	end

	dn@
end

procedure BuildGDMA (* -- *)
	GDMADefault SDMANode!

	if (SDMANode@ 0 ~=)
		SDMANode@ DeviceClone
			"dma" DSetName
		DeviceExit
	end
end