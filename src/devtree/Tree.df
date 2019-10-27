#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

extern BuildPlatform

extern BuildGDMA
extern BuildGSerial
extern BuildGScreen
extern BuildGConsole
extern BuildGKeyboard
extern BuildGMouse
extern BuildGBootDisk
extern BuildGClock
extern BuildGDisk
extern BuildGCPU
extern BuildGMemory

procedure BuildTree (* -- *)
	BuildPlatform

	(* platform independent pseudo-devices *)
	BuildGCPU
	BuildGMemory
	BuildGDMA
	BuildGSerial
	BuildGScreen
	BuildGConsole
	BuildGKeyboard
	BuildGMouse
	BuildGDisk
	BuildGBootDisk
	BuildGClock
end