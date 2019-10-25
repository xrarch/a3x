#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

procedure BuildLimn1k
	DeviceNew
		"limn1k" DSetName
		"limn1k" "type" DAddProperty

		pointerof Limn1kReset "reset" DAddMethod
	DeviceExit
end

asm "

Limn1kReset:
.global Limn1kReset
	lri.l r0, 0xFFFE0000
	br r0

"