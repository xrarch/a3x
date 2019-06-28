var GCFBStart 0
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

const GConsoleFontWidth 6
const GConsoleFontWidthA 5

const GConsoleFontBytesPerRow 1
const GConsoleFontHeight 12

const GConsoleFontBitD 0

var GCEscape 0

var GCLineLenBuf 0

var GCRectP 0
var GCScrollP 0
var GCBBP 0

var GConsoleModified 0

asm "

GConsoleFont:
	.static devtree/gconsole/font-haiku.bmp

"

procedure BuildGConsole (* -- *)
	"/screen" DevTreeWalk GCScreenNode!
	if (GCScreenNode@ 0 ==)
		return
	end

	GCScreenNode@ DeviceSelectNode
		"framebuffer" DGetProperty GCFBStart!
		"width" DGetProperty GCGWidth!
		"height" DGetProperty GCGHeight!

		"rectangle" DGetMethod GCRectP!
		"scroll" DGetMethod GCScrollP!
		"blitBits" DGetMethod GCBBP!
	DeviceExit

	DeviceNew
		"gconsole" DSetName

		pointerof GConsolePutChar "write" DAddMethod
		pointerof GConsoleModifiedF "chkModified" DAddMethod
		pointerof GConsoleSetScreen "setScreen" DAddMethod
		pointerof GConsoleSuppressDraw "suppressDraw" DAddMethod

		GConsoleFontWidth "fontWidth" DAddProperty
		GConsoleFontHeight "fontHeight" DAddProperty
	DeviceExit

	"screen-bg" NVRAMGetVarNum GCColorBG!
	"screen-fg" NVRAMGetVarNum GCColorFG!

	GCGWidth@ GConsoleFontWidth / GCWidth!
	GCGHeight@ GConsoleFontHeight / GCHeight!

	GCHeight@ 4 * Calloc GCLineLenBuf!
end

procedure GConsoleSuppressDraw (* -- *)
	0 GCNeedsDraw!
end

procedure GConsoleSetScreen (* fbp w h prect pscroll -- *)
	0 GConsoleModified!

	GCScrollP!
	GCRectP!

	GCGHeight!
	GCGWidth!
	GCFBStart!

	GCGWidth@ GConsoleFontWidth / GCWidth!
	GCGHeight@ GConsoleFontHeight / GCHeight!

	GConsoleClear
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

		i@ 1 + i!
	end

	longest@
end

procedure GConsoleClear (* -- *)
	0 0 GConsoleLongestLine GConsoleFontWidth * GCHeight@ GConsoleFontHeight * GCColorBG@ GConsoleRect

	0 GCCurX!
	0 GCCurY!

	GCLineLenBuf@ GCHeight@ 4 * 0 memset

	1 GConsoleModified!
end

procedure GConsoleBlitBits (* x y w h bpr fg bg bitd bmp -- *)
	GCScreenNode@ DeviceSelectNode
		GCBBP@ Call
	DeviceExit
end

procedure GConsoleRect (* x y w h color -- *)
	GCScreenNode@ DeviceSelectNode
		GCRectP@ Call
	DeviceExit
end

procedure GConsoleScroll (* rows -- *)
	auto rows
	rows!

	auto rs
	InterruptDisable rs!

	GCScreenNode@ DeviceSelectNode
		0 0
		GConsoleLongestLine GConsoleFontWidth *
		GConsoleFontHeight GCHeight@ * 1 +
		GCColorBG@
		rows@ GConsoleFontHeight *
		GCScrollP@ Call
	DeviceExit

	rs@ InterruptRestore

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
		r@ 4 + r!
	end

	GCHeight@ rows@ - 4 * gclb@ + r!
	GCHeight@ 4 * gclb@ + max!

	while (r@ max@ <)
		0 r@ !
		r@ 4 + r!
	end

	1 GConsoleModified!
end

procedure GConsoleDoCur (* color -- *)
	auto color
	color!

	GCCurX@ GConsoleFontWidth * GCCurY@ GConsoleFontHeight * GConsoleFontWidth GConsoleFontHeight color@ GConsoleRect

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
	GCScreenNode@ DeviceSelectNode
		"init" DCallMethod drop
	DeviceExit
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
	end

	if (GCEV0@ 512 <)
		GCColorBG@ GCColorOBG!
		GCEV0@ 256 - GCColorBG!
		return
	end

	if (GCEV0@ 1024 ==)
		GCColorOBG@ GCColorBG!
		GCColorOFG@ GCColorFG!
		return
	end
end

procedure GConsoleParseEscape (* c -- *)
	auto c
	c!

	if (c@ '0' >= c@ '9' <= &&)
		GCEV@ @ 10 * GCEV@ !
		GCEV@ @ c@ '0' - + GCEV@ !
		return
	end

	if (c@ '[' ==) return end
	if (c@ ';' ==) pointerof GCEV1 GCEV! return end
	if (c@ 'm' ==) GConsoleSetColor end
	if (c@ 'c' ==) GConsoleClear end

	0 GCEscape!
end

procedure GConsolePutChar (* char -- *)
	auto char
	char!

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

procedure GConsolePutCharF (* char -- *)
	auto char
	char!

	if (char@ '\n' ==)
		GConsoleNewline
		return
	end else

	if (char@ '\b' ==)
		GConsoleBack
		return
	end else

	if (char@ '\t' ==)
		GConsoleTab
		return
	end

	end

	end

	GCCurX@ GConsoleFontWidth *
	GCCurY@ GConsoleFontHeight *
	char@
	GCColorFG@
	GConsoleDrawChar

	GCCurX@ 1 + GCCurX!

	if (GCCurX@ GCWidth@ >=)
		GConsoleNewline
	end
end

procedure GConsoleDrawChar (* x y char color -- *)
	auto color
	color!

	auto char
	char!

	auto y
	y!

	auto x
	x!

	(* dont draw spaces *)
	if (char@ ' ' ==)
		return
	end

	if (GCNeedsDraw@)
		GConsoleDraw
		0 GCNeedsDraw!
	end

	auto bmp
	char@ GConsoleFontBytesPerRow GConsoleFontHeight * * pointerof GConsoleFont + bmp!

	x@ y@ GConsoleFontWidth GConsoleFontHeight GConsoleFontBytesPerRow color@ GCColorBG@ GConsoleFontBitD bmp@ GConsoleBlitBits

end