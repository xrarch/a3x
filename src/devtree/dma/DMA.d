(* platform independent keyboard interface, antecedent standard *)

var SDMANode 0

procedure GDMADefault (* -- defaultnode *)
	"dma-dev" NVRAMGetVar dup if (0 ==)
		drop "/ebus/dma" "dma-dev" NVRAMSetVar
		"/ebus/dma"
	end

	auto dn
	DevTreeWalk dn!

	if (dn@ 0 ==)
		"/ebus/dma" "dma-dev" NVRAMSetVar
		"/ebus/dma" DevTreeWalk dn!
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