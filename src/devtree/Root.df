#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

extern BuildTree

procedure DevRootBuild (* -- *)
	"antecedent" DSetName

	pointerof ANTEBDS "buildDate" DAddProperty
	"3.1.6" "version" DAddProperty
	"Will" "author" DAddProperty
	pointerof ANTEBNS "build" DAddProperty

	BuildTree
end

asm "

ANTEBNS:
	.static ../build
	.db 0x0

ANTEBDS:
	.ds$ __DATE
	.db 0x0

"