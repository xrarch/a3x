#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

extern BuildEBus
extern BuildMemory

extern BuildDMA
extern BuildSerial
extern BuildScreen
extern BuildGConsole
extern BuildKeyboard
extern BuildMouse
extern BuildBootDisk
extern BuildClock

procedure BuildTree (* -- *)
	DeviceNew
		"cpu" DSetName
		"limn1k" "type" DAddProperty
	DeviceExit

	BuildEBus

	BuildMemory

	(* platform independent pseudo-devices *)
	BuildDMA
	BuildSerial
	BuildScreen
	BuildGConsole
	BuildKeyboard
	BuildMouse
	BuildBootDisk
	BuildClock
end