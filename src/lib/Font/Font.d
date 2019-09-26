#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

var FontScreenNode 0

var FontBBP 0

asm "

Font:
	.static font-haiku.bmp

"

procedure FontInit (* -- *)
	"/screen" DevTreeWalk FontScreenNode!
	if (FontScreenNode@ 0 ==)
		return
	end

	FontScreenNode@ DeviceSelectNode
		"blitBits" DGetMethod FontBBP!
	DeviceExit
end

procedure private FontBlitBits (* bpr fg bg bitd bmp x y w h -- *)
	FontScreenNode@ DeviceSelectNode
		FontBBP@ Call
	DeviceExit
end

procedure FontDrawChar (* x y char bg color -- *)
	auto color
	color!

	auto bg
	bg!

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

	auto bmp
	char@ FontBytesPerRow FontHeight * * pointerof Font + bmp!

	FontBytesPerRow color@ bg@ FontBitD bmp@ x@ y@ FontWidth FontHeight FontBlitBits
end

procedure FontDrawString (* x y string bg color -- *)
	auto color
	color!

	auto bg
	bg!

	auto str
	str!

	auto y
	y!

	auto x
	x!

	auto sx
	x@ sx!

	auto c
	str@ gb c!

	while (c@ 0 ~=)
		if (c@ '\n' ==)
			y@ FontHeight + y!
			sx@ x!
		end else
			x@ y@ c@ bg@ color@ FontDrawChar

			x@ FontWidth + x!
		end

		str@ 1 + str!
		str@ gb c!
	end
end