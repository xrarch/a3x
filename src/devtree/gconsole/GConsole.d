#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

var GCGWidth 0
var GCGHeight 0

var GCColorBG 0x56
var GCColorFG 0x00

var GCColorOBG 0x56
var GCColorOFG 0x00

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

procedure GConsoleDefault (* -- *)
	GCScreenNode@ DeviceSelectNode
		"width" DGetProperty GCGWidth!
		"height" DGetProperty GCGHeight!
	DeviceExit

	"screen-bg" NVRAMGetVarNum dup GCColorBG! GCColorOBG!
	"screen-fg" NVRAMGetVarNum dup GCColorFG! GCColorOFG!

	GCGWidth@ FontWidth / GCWidth!
	GCGHeight@ FontHeight / GCHeight!

	0 GConsoleX!
	0 GConsoleY!

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

		pointerof GConsolePutChar "write" DAddMethod
		pointerof GConsoleModifiedF "chkModified" DAddMethod
		pointerof GConsoleSetScreen "setScreen" DAddMethod
		pointerof GConsoleSuppressDraw "suppressDraw" DAddMethod

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

	fg@ dup GCColorFG! GCColorOFG!
	bg@ dup GCColorBG! GCColorOBG!

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
		FontHeight GCHeight@ * 1 +
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

var GCEV0 0
var GCEV1 0

var GCEV 0

procedure GConsoleSetColor (* -- *)
	if (GCEV0@ 256 <)
		GCColorFG@ GCColorOFG!
		GCEV0@ GCColorFG!
		return
	end elseif (GCEV0@ 512 <)
		GCColorBG@ GCColorOBG!
		GCEV0@ 256 - GCColorBG!
		return
	end elseif (GCEV0@ 1024 ==)
		GCColorOBG@ GCColorBG!
		GCColorOFG@ GCColorFG!
		return
	end
end

procedure GConsoleParseEscape { c -- }
	if (c@ '0' >= c@ '9' <= &&)
		GCEV@ @ 10 * GCEV@ !
		GCEV@ @ c@ '0' - + GCEV@ !
		return
	end

	if (c@ '[' ==) return end
	elseif (c@ ';' ==) pointerof GCEV1 GCEV! return end
	elseif (c@ 'm' ==) GConsoleSetColor end
	elseif (c@ 'c' ==) GConsoleClear end

	0 GCEscape!
end

procedure GConsolePutChar { char -- }
	if (char@ 255 >)
		return
	end

	if (GCEscape@) char@ GConsoleParseEscape return end

	if (char@ 0x1b ==)
		pointerof GCEV0 GCEV!
		0 GCEV0!
		0 GCEV1!
		1 GCEscape!
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