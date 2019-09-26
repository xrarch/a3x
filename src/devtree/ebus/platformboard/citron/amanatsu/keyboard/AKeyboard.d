#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

var AKeyboardDev 0
var AKeyboardCount 0

const AKeyboardMID 0x8FC48FC4

procedure AKeyboardPoll (* -- *)
	auto i
	1 i!

	while (i@ 256 <)
		auto rs
		InterruptDisable rs!

		if (i@ AmanatsuPoll AKeyboardMID ==)
			auto hmm
			5 Calloc hmm!

			AKeyboardDev@ DeviceSelectNode

				DeviceNew
					AKeyboardCount@ hmm@ itoa

					hmm@ DSetName

					i@ "aID" DAddProperty

					pointerof AKeyboardRead "read" DAddMethod

					AKeyboardCount@ 1 + AKeyboardCount!
				DeviceExit
			DeviceExit
		end

		rs@ InterruptRestore

		i@ 1 + i!
	end
end

procedure AKeyboardPopCode (* id -- code *)
	auto id
	id!

	auto rs
	InterruptDisable rs!

	auto code

	id@ AmanatsuSelectDev
	1 AmanatsuCommand
	AmanatsuReadA code!

	rs@ InterruptRestore

	code@
end

procedure AKeyboardSpecial (* code -- *)
	auto code
	code!

	if (code@ 50 ==)
		'\n' return
	end
	if (code@ 51 ==)
		'\b' return
	end

	ERR return
end

procedure AKeyboardRead (* -- c *)
	auto id
	"aID" DGetProperty id!

	auto code

	id@ AKeyboardPopCode code!

	if (code@ 0xFFFF ==)
		ERR return
	end

	auto c

	if (code@ 0xF0 ==) (* shift *)

		id@ AKeyboardPopCode code!

		if (code@ 50 >=) code@ AKeyboardSpecial return end

		[code@]AKeyboardLayoutShift@ c!

	end else if (code@ 0xF1 ==) (* ctrl *)

		id@ AKeyboardPopCode code!

		if (code@ 50 >=) code@ AKeyboardSpecial return end

		[code@]AKeyboardLayoutCtrl@ c!

	end else

		if (code@ 50 >=) code@ AKeyboardSpecial return end

		[code@]AKeyboardLayout@ c!

	end
	end

	c@
end

procedure AKeyboardInit (* -- *)
	DeviceNew
		"kbd" DSetName
		DevCurrent@ AKeyboardDev!
	DeviceExit
end

table AKeyboardLayout
	'a'
	'b' 'c' 'd'
	'e' 'f' 'g'
	'h' 'i' 'j'
	'k' 'l' 'm'
	'n' 'o' 'p'
	'q' 'r' 's'
	't' 'u' 'v'
	'w' 'x' 'y'
	'z'
	'0' '1' '2'
	'3' '4' '5'
	'6' '7' '8'
	'9'
	';'
	' '
	' '
	'-'
	'='
	'['
	']'
	'\\'
	0
	'/'
	'.'
	'\''
	','
	'`'
endtable

table AKeyboardLayoutCtrl
	'a'
	'b' 'c' 'd'
	'e' 'f' 'g'
	'h' 'i' 'j'
	'k' 'l' 'm'
	'n' 'o' 'p'
	'q' 'r' 's'
	't' 'u' 'v'
	'w' 'x' 'y'
	'z'
	'0' '1' '2'
	'3' '4' '5'
	'6' '7' '8'
	'9'
	';'
	' '
	' '
	'-'
	'='
	'['
	']'
	'\\'
	0
	'/'
	'.'
	'\''
	','
	'`'
endtable

table AKeyboardLayoutShift
	'A'
	'B' 'C' 'D'
	'E' 'F' 'G'
	'H' 'I' 'J'
	'K' 'L' 'M'
	'N' 'O' 'P'
	'Q' 'R' 'S'
	'T' 'U' 'V'
	'W' 'X' 'Y'
	'Z'
	')' '!' '@'
	'#' '$' '%'
	'^' '&' '*'
	'('
	':'
	' '
	' '
	'_'
	'+'
	'{'
	'}'
	'|'
	0
	'?'
	'>'
	'"'
	'<'
	'~'
endtable