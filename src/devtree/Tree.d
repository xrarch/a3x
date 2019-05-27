#include "devtree/Memory.d"
#include "devtree/ebus/EBus.d"
#include "devtree/dma/DMA.d"
#include "devtree/screen/Screen.d"
#include "devtree/serial/Serial.d"
#include "devtree/gconsole/GConsole.d"
#include "devtree/mouse/Mouse.d"
#include "devtree/keyboard/Keyboard.d"
#include "devtree/bootdisk/BootDisk.d"
#include "devtree/clock/Clock.d"

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