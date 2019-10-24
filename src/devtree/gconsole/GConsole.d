#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

var GCGWidth 0
var GCGHeight 0

var GCColorBG 0x00
var GCColorFG 0x00

var GCColorDefBG 0x00
var GCColorDefFG 0x00

var GCCurX 0
var GCCurY 0

var GCWidth 0
var GCHeight 0

var GCScreenNode 0

var GCNeedsDraw 1

var GCInitialConfig 1

var GCEscape 0

var GCLineLenBuf 0

var GCRectP 0
var GCScrollP 0

var GConsoleX 0
var GConsoleY 0

var GConsoleModified 0

var GCInverted 0

table ColorIndex
	0
	4
	72
	44
	1
	36
	52
	28
endtable

table ColorIndex2
	20
	89
	74
	92
	102
	60
	100
	15
endtable

procedure GConsoleDefault (* -- *)
	GCScreenNode@ DeviceSelectNode
		"width" DGetProperty GCGWidth!
		"height" DGetProperty GCGHeight!
	DeviceExit

	"screen-bg" NVRAMGetVarNum dup GCColorDefBG! GCColorBG!
	"screen-fg" NVRAMGetVarNum dup GCColorDefFG! GCColorFG!

	if ("console-rows" NVRAMGetVar 0 ==)
		34 "console-rows" NVRAMSetVarNum
	end
	if ("console-cols" NVRAMGetVar 0 ==)
		80 "console-cols" NVRAMSetVarNum
	end

	auto crows
	"console-rows" NVRAMGetVarNum crows!
	auto ccols
	"console-cols" NVRAMGetVarNum ccols!

	GCGWidth@ FontWidth / ccols@ min GCWidth!
	GCGHeight@ FontHeight / crows@ min GCHeight!

	GCGWidth@ 2 / GCWidth@ FontWidth * 2 / - GConsoleX!
	GCGHeight@ 2 / GCHeight@ FontHeight * 2 / - GConsoleY!

	0 GCCurX!
	0 GCCurY!

	GCLineLenBuf@ GCHeight@ 4 * 0 memset

	1 GCInitialConfig!
	1 GCNeedsDraw!
end

procedure BuildGConsole (* -- *)
	"/screen" DevTreeWalk GCScreenNode!
	if (GCScreenNode@ 0 ==)
		return
	end

	1024 Calloc GCLineLenBuf!

	GCScreenNode@ DeviceSelectNode
		"rectangle" DGetMethod GCRectP!
		"scroll" DGetMethod GCScrollP!
	DeviceExit

	DeviceNew
		"gconsole" DSetName

		pointerof GConsoleModifiedF "chkModified" DAddMethod
		pointerof GConsoleSetScreen "setScreen" DAddMethod
		pointerof GConsoleSuppressDraw "suppressDraw" DAddMethod
		pointerof GConsolePutChar "write" DAddMethod

		FontWidth "fontWidth" DAddProperty
		FontHeight "fontHeight" DAddProperty
	DeviceExit

	GConsoleDefault
end

procedure GConsoleSuppressDraw (* -- *)
	0 GCNeedsDraw!
end

procedure GConsoleSetScreen { fg bg x y w h -- }
	if (x@ -1 ==)
		GConsoleDefault
		return
	end

	x@ GConsoleX!
	y@ GConsoleY!

	0 GCCurX!
	0 GCCurY!

	w@ dup FontWidth / GCWidth! GCGWidth!
	h@ dup FontHeight / GCHeight! GCGHeight!

	fg@ dup GCColorFG! GCColorDefFG!
	bg@ dup GCColorBG! GCColorDefBG!

	GCLineLenBuf@ GCHeight@ 4 * 0 memset

	0 GCInitialConfig!
end

procedure GConsoleModifiedF (* -- modified? *)
	GConsoleModified@

	0 GConsoleModified!
end

procedure GConsoleLongestLine (* -- width *)
	auto i
	0 i!

	auto longest
	0 longest!

	while (i@ GCHeight@ <)
		auto len
		i@ 4 * GCLineLenBuf@ + @ len!

		if (len@ longest@ >)
			len@ longest!
		end

		1 i +=
	end

	longest@
end

procedure GConsoleClear (* -- *)
	0 0 GConsoleLongestLine FontWidth * GCHeight@ FontHeight * GCColorBG@ GConsoleRect

	0 GCCurX!
	0 GCCurY!

	GCLineLenBuf@ GCHeight@ 4 * 0 memset

	1 GConsoleModified!
end

procedure GConsoleRect { x y w h color -- }
	GCScreenNode@ DeviceSelectNode
		x@ GConsoleX@ +
		y@ GConsoleY@ +
		w@ h@
		color@
		GCRectP@ DCallMethodPtr
	DeviceExit
end

procedure GConsoleScroll { rows -- }
	GCScreenNode@ DeviceSelectNode
		GConsoleX@ GConsoleY@
		GConsoleLongestLine FontWidth *
		FontHeight GCHeight@ *
		GCColorBG@
		rows@ FontHeight *
		GCScrollP@ DCallMethodPtr
	DeviceExit

	auto k
	GCHeight@ k!

	auto gclb
	GCLineLenBuf@ gclb!

	auto r
	gclb@ r!

	auto max
	GCHeight@ rows@ - 4 * gclb@ + max!

	while (r@ max@ <)
		r@ rows@ 4 * + @ r@ !
		4 r +=
	end

	GCHeight@ rows@ - 4 * gclb@ + r!
	GCHeight@ 4 * gclb@ + max!

	while (r@ max@ <)
		0 r@ !
		4 r +=
	end

	1 GConsoleModified!
end

procedure GConsoleDoCur { color -- }
	GCCurX@ FontWidth * GCCurY@ FontHeight * FontWidth FontHeight color@ GConsoleRect

	1 GConsoleModified!
end

procedure GConsoleClearCur (* -- *)
	GCColorBG@ GConsoleDoCur
end

procedure GConsoleDrawCur (* -- *)
	GCColorFG@ GConsoleDoCur
end

procedure GConsoleNewline (* -- *)
	GCCurX@ GCCurY@ 4 * GCLineLenBuf@ + !

	0 GCCurX!
	GCCurY@ 1 + GCCurY!

	if (GCCurY@ GCHeight@ >=)
		GCHeight@ 1 - GCCurY!
		0 GCCurX!
		1 GConsoleScroll
	end
end

procedure GConsoleBack (* -- *)
	if (GCCurX@ 0 ==)
		if (GCCurY@ 0 >)
			GCCurY@ 1 - GCCurY!
			GCWidth@ 1 - GCCurX!
		end
		return
	end

	GCCurX@ 1 - GCCurX!
end

procedure GConsoleDraw (* -- *)
	if (GCInitialConfig@)
		GCScreenNode@ DeviceSelectNode
			"init" DCallMethod drop
		DeviceExit
	end
end

procedure GConsoleTab (* -- *)
	GCCurX@ 8 / 1 + 8 * GCCurX!

	if (GCCurX@ GCWidth@ >=)
		GConsoleNewline
	end
end

table GCEVT
	0
	0
	0
	0
endtable

const GCEVC 4

var GCEV 0

procedure GConsoleSetColor (* -- *)
	if ([0]GCEVT@ 0 ==)
		GCColorDefFG@ GCColorFG!
		GCColorDefBG@ GCColorBG!

		0 GCInverted!

		return
	end elseif ([0]GCEVT@ 7 ==)
		if (GCInverted@ ~~)
			GCColorFG@ GCColorBG@ GCColorFG! GCColorBG!

			1 GCInverted!
		end

		return
	end elseif ([0]GCEVT@ 39 ==)
		GCColorDefFG@ GCColorFG!
	end elseif ([0]GCEVT@ 49 ==)
		GCColorDefBG@ GCColorBG!
	end elseif ([0]GCEVT@ 30 >= [0]GCEVT@ 37 <= &&) (* foreground, first 8 *)
		auto color

		[0]GCEVT@ 30 - color!

		[color@]ColorIndex@ GCColorFG!
	end elseif ([0]GCEVT@ 40 >= [0]GCEVT@ 47 <= &&) (* background, first 8 *)
		[0]GCEVT@ 40 - color!

		[color@]ColorIndex@ GCColorBG!
	end elseif ([0]GCEVT@ 90 >= [0]GCEVT@ 97 <= &&) (* foreground, second 8 *)
		[0]GCEVT@ 90 - color!

		[color@]ColorIndex2@ GCColorFG!
	end elseif ([0]GCEVT@ 100 >= [0]GCEVT@ 107 <= &&) (* background, second 8 *)
		[0]GCEVT@ 100 - color!

		[color@]ColorIndex2@ GCColorBG!
	end elseif ([1]GCEVT@ 5 ==)
		if ([0]GCEVT@ 38 ==)
			[2]GCEVT@ GCColorFG!
		end elseif ([0]GCEVT@ 48 ==)
			[2]GCEVT@ GCColorBG!
		end
	end
end

procedure GConsoleClearLine (* -- *)
	auto ox
	GCCurX@ ox!

	while (GCCurX@ 0 >)
		'\b' GConsolePutChar
	end

	ox@ GCCurX!
end

procedure GConsoleReset (* -- *)
	GCColorDefFG@ GCColorFG!
	GCColorDefBG@ GCColorBG!

	0 GCInverted!

	GConsoleClear
end

procedure GConsoleParseEscape { c -- }
	if (c@ '0' >= c@ '9' <= &&)
		auto np
		GCEV@ 4 * GCEVT + np!

		10 np@ *=
		c@ '0' - np@ +=

		return
	end

	if (c@ '[' ==) return end
	elseif (c@ ';' ==) GCEV@ 1 + GCEVC % GCEV! return end
	elseif (c@ 'm' ==) GConsoleSetColor end
	elseif (c@ 'c' ==) GConsoleReset end
	elseif (c@ 'K' ==) GConsoleClearLine end

	0 GCEscape!
end

procedure GConsolePutChar { char -- }
	if (char@ 255 >)
		return
	end

	if (GCEscape@) char@ GConsoleParseEscape return end

	if (char@ 0x1b ==)
		0 GCEV!
		1 GCEscape!
		GCEVT GCEVC 4 * 0 memset
		return
	end

	GConsoleClearCur

	char@ GConsolePutCharF

	GConsoleDrawCur
end

procedure GConsolePutCharF { char -- }
	if (char@ '\n' ==)
		GConsoleNewline
		return
	end elseif (char@ '\b' ==)
		GConsoleBack
		return
	end elseif (char@ '\t' ==)
		GConsoleTab
		return
	end elseif (char@ '\r' ==)
		0 GCCurX!
		return
	end

	if (GCNeedsDraw@)
		GConsoleDraw
		0 GCNeedsDraw!
	end

	GCCurX@ FontWidth * GConsoleX@ +
	GCCurY@ FontHeight * GConsoleY@ +
	char@
	GCColorBG@
	GCColorFG@
	FontDrawChar

	GCCurX@ 1 + GCCurX!

	if (GCCurX@ GCWidth@ >=)
		GConsoleNewline
	end
end