#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

extern HeapInit
extern ConsoleEarlyInit
extern InterruptsInit
extern DeviceInit
extern ConsoleInit
extern FaultsRegister
extern FontInit
extern PECInit

extern Main

(* MUST be at the top *)
procedure AntecedentEntry (* -- *)
	HeapInit
	ConsoleEarlyInit
	(* print routines now work, do NOT use them before this *)

	"Welcome to ANTECEDENT 3.x\n" Printf

	if (NVRAMCheck ~~)
		"nvram corrupted! formatting\n" Printf
		NVRAMFormat
	end

	InterruptsInit
	PECInit
	DeviceInit

	FirmwareBanner

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

procedure BannerPrint (* ... -- *)
	Printf
end

procedure FirmwareBanner (* -- *)
	CR

	"/" DeviceSelect
		"boot firmware up\n" BannerPrint
		"author" DGetProperty "version" DGetProperty DGetName "Implementation details: %s %s written by %s\n" BannerPrint
		"platform" DGetProperty "Platform: %s\n" BannerPrint
		"buildDate" DGetProperty "build" DGetProperty "Build %s, built on %s\n" BannerPrint
	DeviceExit

	"/cpu" DeviceSelect
		"type" DGetProperty "CPU type: %s\n" BannerPrint
	DeviceExit

	"/memory" DeviceSelect
		"totalRAM" DGetProperty 1024 / "RAM: %dkb\n" BannerPrint
	DeviceExit

	CR
end