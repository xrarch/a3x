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

	if (1)
		"\n\tSetting up ebus... " Puts
		BuildEBus
		"complete!" Puts  
	end
	else
		"\n\tebus disabled..." Puts *)
	end
	"\n\tSetting up memory... " Puts

	BuildMemory
	"complete!\n\tSetting up DMA... " Puts

	(* platform independent pseudo-devices *)
	BuildGDMA
	"complete!\n\tSetting up Serial... " Puts
	BuildSerial
	"complete!\n\tSetting up Screen... " Puts
	BuildScreen
	"complete!\n\tSetting up GConsole... " Puts
	BuildGConsole
	"complete!\n\tSetting up Keyboard... " Puts
	BuildKeyboard
	"complete!\n\tSetting up Mouse... " Puts
	BuildMouse
	"complete!\n\tSetting up BootDisk... " Puts
	BuildBootDisk
	"complete!\n\tSetting up Clock... " Puts
	BuildClock
	"complete!\n" Puts
end
