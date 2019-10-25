#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

var InterruptsVT 0

procedure InterruptsInit (* -- *)
	auto oivt

	asm "

	pushv r5, ivt

	" oivt!

	1024 Calloc InterruptsVT!

	oivt@ FaultsCopy

	InterruptsVT@ asm "
		popv r5, r0
		cli
		mov ivt, r0
	"

	InterruptEnable
end

procedure FaultsCopy { oivt -- }
	auto i
	0 i!
	while (i@ 10 <)
		oivt@ @ i@ InterruptRegister
		1 i +=
		4 oivt +=
	end
end

procedure FaultsRegister (* -- *)
	auto i
	0 i!
	while (i@ 10 <)
		pointerof FaultsHandlerASM i@ InterruptRegister
		1 i +=
	end
end

table FaultsNames
	"Division by zero"
	"Invalid opcode"
	"Page fault"
	"Privilege violation"
	"General fault"
	"Breakpoint"
	"Unknown"
	"Bus error"
	"Unknown"
	"Spurious interrupt"
endtable
public FaultsNames

const Breakpoint 5

procedure FaultsHandler { num loc -- }
	auto rs
	InterruptDisable rs!

	ConsoleUserOut



	if (ConsoleInMethod@ 0 ~=)
		if (num@ Breakpoint ==)
			"!!! BREAKPOINT !!!\n" Printf
			Monitor
			return
		end else
			loc@ [num@]FaultsNames@ "\n!!!FAULT!!! %s at %x, resetting on console input.
\t'c' to clear NVRAM.
\t'v' to clear NVRAM and set 'verbose?'='true'.
\t'b' to only set 'auto-boot?'='false'.
\t'm' to enter the monitor.
\tany other key to reset normally.\n" Printf

			auto c
			ERR c!
			while (c@ ERR ==)
				Getc c!
			end

			if (c@ 'c' ==)
				NVRAMFormat
			end elseif (c@ 'v' ==)
				NVRAMFormat
				"true" "verbose?" NVRAMSetVar
			end elseif (c@ 'b' ==)
				"false" "auto-boot?" NVRAMSetVar
			end elseif (c@ 'm' ==)
				Monitor return
			end

			LateReset
		end
	end else
		loc@ [num@]FaultsNames@ "\n!!!FAULT!!! %s at %x, resetting.\n" Printf

		LateReset
	end
end

asm "

FaultsHandlerASM:
	pop k3 ;rs
	pop k2 ;r0
	pop k1 ;pc

	push k1
	push k2
	push k3

	pusha

	pushv r5, r0

	pushv r5, k1

	call FaultsHandler

	popa

	iret
"

procedure InterruptRegister (* handler num -- *)
	4 * InterruptsVT@ + !
end

procedure InterruptEnable (* -- *)
	asm "

	bseti rs, rs, 1

	"
end

procedure InterruptDisable (* -- rs *)
	asm "

	mov r0, rs
	bclri rs, rs, 1
	pushv r5, r0

	"
end

procedure InterruptRestore (* rs -- *)
	asm "

	popv r5, r0
	mov rs, r0

	"
end