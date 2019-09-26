#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

extern HeapInit
extern InterruptsInit
extern DeviceInit
extern ConsoleInit
extern FaultsRegister
extern FontInit

extern Main

(* MUST be at the top *)
procedure AntecedentEntry (* -- *)
	if (NVRAMCheck ~~)
		NVRAMFormat
	end

	HeapInit
	InterruptsInit
	DeviceInit
	ConsoleInit

	FaultsRegister (* let llfw handle faults up until here *)

	FontInit

	Main
end

asm "

Reset:
.global Reset
	lri.l r0, 0xFFFE0000
	br r0

"

procedure LateReset (* -- *)
	"\[c" Printf
	Reset
end