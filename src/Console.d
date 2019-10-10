#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

var ConsoleOut 0
public ConsoleOut

var ConsoleIn 0
public ConsoleIn

var ConsoleOutMethod 0
public ConsoleOutMethod

var ConsoleInMethod 0
public ConsoleInMethod

procedure ConsoleSetIn { dn -- }
	dn@ ConsoleIn!

	if (dn@ 0 ==)
		0 ConsoleIn!
		0 ConsoleInMethod!
		return
	end

	dn@ DeviceSelectNode
		"read" DGetMethod ConsoleInMethod!
	DeviceExit
end

procedure ConsoleSetOut { dn -- }
	dn@ ConsoleOut!

	if (dn@ 0 ==)
		0 ConsoleOut!
		0 ConsoleOutMethod!
		return
	end

	dn@ DeviceSelectNode
		"write" DGetMethod ConsoleOutMethod!
	DeviceExit
end

procedure Putc { c -- }
	ConsoleOut@ DeviceSelectNode
		c@ ConsoleOutMethod@ Call
	DeviceExit
end

procedure Getc { -- c }
	if (ConsoleInMethod@ 0 ==) ERR return end

	ConsoleIn@ DeviceSelectNode
		ConsoleInMethod@ Call c!
	DeviceExit
end

(* try to redirect stdout/stdin to /gconsole and /keyboard if these nodes exist *)
procedure ConsoleUserOut (* -- *)
	auto gcn
	"/gconsole" DevTreeWalk gcn!

	auto kbn
	"/keyboard" DevTreeWalk kbn!

	if (gcn@)
		gcn@ ConsoleSetOut

		if (kbn@)
			kbn@ ConsoleSetIn
		end
	end
end

procedure ConsoleInit (* -- *)
	auto co
	auto ci

	"console-stdout" NVRAMGetVar dup if (0 ==)
		drop "/serial" "console-stdout" NVRAMSetVar
		"/serial"
	end

	DevTreeWalk co!

	"console-stdin" NVRAMGetVar dup if (0 ==)
		drop "/serial" "console-stdin" NVRAMSetVar
		"/serial"
	end

	DevTreeWalk ci!

	co@ ConsoleSetOut
	ci@ ConsoleSetIn

	if (ConsoleOut@ 0 ==)
		"/serial" DevTreeWalk ConsoleSetOut
	end

	if (ConsoleIn@ 0 ==)
		"/serial" DevTreeWalk ConsoleSetIn
	end
end