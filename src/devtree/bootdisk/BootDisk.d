#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* platform independent keyboard interface, antecedent standard *)

var SBootDiskNode 0

procedure GBootDiskDefault (* -- defaultnode *)
	"boot-dev" NVRAMGetVar dup if (0 ==)
		drop "/ebus/platformboard/citron/dks/0/a" "boot-dev" NVRAMSetVar
		"/ebus/platformboard/citron/dks/0/a"
	end

	auto dn
	DevTreeWalk dn!

	dn@
end

procedure BuildBootDisk (* -- *)
	GBootDiskDefault SBootDiskNode!

	if (SBootDiskNode@ 0 ~=)
		SBootDiskNode@ DeviceClone
			"bootdisk" DSetName

			SBootDiskNode@ "bootAlias" DAddProperty
		DeviceExit
	end
end