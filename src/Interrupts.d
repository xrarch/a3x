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

procedure FaultsCopy (* oivt -- *)
	auto oivt
	oivt!

	auto i
	0 i!
	while (i@ 10 <)
		oivt@ @ i@ InterruptRegister
		i@ 1 + i!
		oivt@ 4 + oivt!
	end
end

procedure FaultsRegister (* -- *)
	auto i
	0 i!
	while (i@ 10 <)
		pointerof FaultsHandlerASM i@ InterruptRegister
		i@ 1 + i!
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

procedure FaultsHandler (* num loc -- *)
	auto rs
	InterruptDisable rs!

	auto loc
	loc!

	auto num
	num!

	"verbose-fault?" NVRAMGetVar dup if (0 ==)
		drop "false" "verbose-fault?" NVRAMSetVar
		"false"
	end

	if ("true" strcmp)
		ConsoleUserOut
	end

	if (ConsoleInMethod@ 0 ~=)
		loc@ [num@]FaultsNames@ "\n!!!FAULT!!! %s at %x, resetting on console input.\n\t'c' to clear NVRAM.\n\t'v' to clear NVRAM and set 'verbose?'='true'.\n\t'b' to only set 'auto-boot?'='false'.\n\tany other key to reset normally.\n" Printf

		auto c
		ERR c!
		while (c@ ERR ==)
			Getc c!
		end

		if (c@ 'c' ==)
			NVRAMFormat
		end else

		if (c@ 'v' ==)
			NVRAMFormat
			"true" "verbose?" NVRAMSetVar
		end else

		if (c@ 'b' ==)
			"false" "auto-boot?" NVRAMSetVar
		end

		end

		end

		LateReset
	end else
		loc@ [num@]FaultsNames@ "\n!!!FAULT!!! %s at %x, resetting.\n" Printf

		LateReset
	end
end

asm "

FaultsHandlerASM:
	pop r1
	pop r1
	pop r1

	li sp, 0x2000 ;put stack in known location
	li r5, 0x1000 ;this too

	pushv r5, r0

	mov r0, r1
	pushv r5, r0

	call FaultsHandler

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