#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

(* antecedent driver for Kinnow3 framebuffer *)

var KinnowSlotSpace 0
var KinnowSlot 0

var KinnowFBStart 0
var KinnowPipeStart 0

const KinnowCmdPorts 0x4000
const KinnowSlotFB 0x100000

const KinnowSlotMID 0x4B494E58

const KinnowGPUCmdPort 0
const KinnowGPUPortA 4
const KinnowGPUPortB 8
const KinnowGPUPortC 12
const KinnowGPUPixelPipe 16

const KinnowGPUInfo 0x1
const KinnowGPURectangle 0x2
const KinnowGPUScroll 0x3
const KinnowGPUVsync 0x4
const KinnowGPUSetPPR 0x5
const KinnowGPUSetPPW 0x6
const KinnowGPUSetPPI 0x7
const KinnowGPUS2S 0x8
const KinnowGPUSetMode 0x9

var KinnowDMANode 0
var KinnowDMATransfer 0

var KinnowWidth 0
var KinnowHeight 0

var KinnowVsyncList 0

var KinnowNeedsInit 1

procedure KinnowCommand { cmd -- }
	auto pbase
	KinnowSlotSpace@ KinnowCmdPorts + pbase!

	cmd@ pbase@ sb

	while (pbase@ gb 0 ~=) end
end

procedure KinnowPortA (* -- v *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortA + @
end

procedure KinnowPortB (* -- v *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortB + @
end

procedure KinnowPortC (* -- v *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortC + @
end

procedure KinnowOutPortA (* v -- *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortA + !
end

procedure KinnowOutPortB (* v -- *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortB + !
end

procedure KinnowOutPortC (* v -- *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortC + !
end

procedure KinnowSetMode { mode -- }
	auto rs
	InterruptDisable rs!

	mode@ KinnowOutPortA

	KinnowGPUSetMode KinnowCommand

	rs@ InterruptRestore
end

procedure KinnowInfo { -- h w }
	auto rs
	InterruptDisable rs!

	KinnowGPUInfo KinnowCommand
	
	KinnowPortB h!
	KinnowPortA w!

	rs@ InterruptRestore
end

procedure KinnowSetPixelRead { x y w h -- }
	auto rs
	InterruptDisable rs!

	auto cxy
	x@ 16 << y@ | cxy!

	auto cwh
	w@ 16 << h@ | cwh!

	cxy@ KinnowOutPortA
	cwh@ KinnowOutPortB

	KinnowGPUSetPPR KinnowCommand

	rs@ InterruptRestore
end

procedure KinnowSetPixelWriteRaw { x y w h fg bg bitd writetype -- }
	auto rs
	InterruptDisable rs!

	auto cxy
	x@ 16 << y@ | cxy!

	auto cwh
	w@ 16 << h@ | cwh!

	auto fbw
	fg@ 24 << bg@ 16 << | bitd@ 8 << | writetype@ | fbw!

	cxy@ KinnowOutPortA
	cwh@ KinnowOutPortB
	fbw@ KinnowOutPortC

	KinnowGPUSetPPW KinnowCommand

	rs@ InterruptRestore
end

procedure KinnowSetPixelWriteBits (* x y w h fg bg bitd -- *)
	1 KinnowSetPixelWriteRaw
end

procedure KinnowSetPixelWrite (* x y w h -- *)
	0 0 0 0 KinnowSetPixelWriteRaw
end

procedure KinnowSetPixelIgnore { color -- }
	auto rs
	InterruptDisable rs!

	color@ KinnowOutPortA

	KinnowGPUSetPPI KinnowCommand

	rs@ InterruptRestore
end

procedure BuildKinnow3 (* -- *)
	auto kslot
	KinnowSlotMID EBusFindFirstBoard kslot!

	if (kslot@ ERR ==)
		return
	end

	kslot@ EBusSlotSpace * EBusSlotsStart + KinnowSlotSpace!

	kslot@ KinnowSlot!

	auto w
	auto h
	KinnowInfo w! h!

	if (w@ 0 ==)
		return
	end

	KinnowSlotSpace@ KinnowSlotFB + KinnowFBStart!
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPixelPipe + KinnowPipeStart!

	DeviceNew
		"kinnow3" DSetName

		KinnowFBStart@ "framebuffer" DAddProperty
		w@ "width" DAddProperty
		h@ "height" DAddProperty
		8 "depth" DAddProperty

		pointerof KinnowRectangle "rectangle" DAddMethod
		pointerof KinnowScroll "scroll" DAddMethod
		pointerof KinnowVsyncAdd "vsyncAdd" DAddMethod
		pointerof KinnowBlit "blit" DAddMethod
		pointerof KinnowBlitBack "blitBack" DAddMethod
		pointerof KinnowBlitS2S "blitS2S" DAddMethod
		pointerof KinnowBlitBits "blitBits" DAddMethod
		pointerof KinnowInit "init" DAddMethod
		pointerof KinnowSetMode "kinnow3,setMode" DAddMethod
	DeviceExit

	w@ KinnowWidth!
	h@ KinnowHeight!

	ListCreate KinnowVsyncList!

	KinnowVsyncOn

	1 KinnowSetMode
end

procedure KinnowBlitS2S { x1 y1 x2 y2 w h -- }
	(* todo *)
end

procedure KinnowPipeRead { to count -- }
	if (KinnowDMANode@ 0 ==)
		auto ndma
		"/dma" DevTreeWalk ndma!

		if (ndma@ 0 ~=)
			ndma@ KinnowDMANode!

			ndma@ DeviceSelectNode
				"transfer" DGetMethod KinnowDMATransfer!
			DeviceExit
		end
	end

	if (KinnowDMANode@ 0 ~=)
		KinnowDMANode@ DeviceSelectNode
			KinnowPipeStart@ to@
			0 1
			count@
			0
			KinnowDMATransfer@ DCallMethodPtr
		DeviceExit
	end else
		auto i
		0 i!
		while (i@ count@ <)
			KinnowPipeStart@ gb to@ sb

			1 to +=
			1 i +=
		end
	end
end

procedure KinnowPipeWrite { from count -- }
	if (KinnowDMANode@ 0 ==)
		auto ndma
		"/dma" DevTreeWalk ndma!

		if (ndma@ 0 ~=)
			ndma@ KinnowDMANode!

			ndma@ DeviceSelectNode
				"transfer" DGetMethod KinnowDMATransfer!
			DeviceExit
		end
	end

	if (KinnowDMANode@ 0 ~=)
		KinnowDMANode@ DeviceSelectNode
			from@ KinnowPipeStart@
			1 0
			count@
			0
			KinnowDMATransfer@ DCallMethodPtr
		DeviceExit
	end else
		auto i
		0 i!
		while (i@ count@ <)
			from@ gb KinnowPipeStart@ sb

			1 from +=
			1 i +=
		end
	end
end

procedure KinnowBlitBack { x y w h ptr -- }
	x@ y@ w@ h@ KinnowSetPixelRead

	ptr@ w@ h@ * KinnowPipeRead
end

procedure KinnowBlit { x y w h ignore ptr -- }
	ignore@ KinnowSetPixelIgnore
	x@ y@ w@ h@ KinnowSetPixelWrite

	ptr@ w@ h@ * KinnowPipeWrite
end

procedure KinnowBlitBits { bpr fg bg bitd ptr x y w h -- }
	x@ y@ w@ h@ fg@ bg@ bitd@ KinnowSetPixelWriteBits

	ptr@ bpr@ h@ * KinnowPipeWrite
end

procedure KinnowInit (* -- *)
	if (KinnowNeedsInit@)
		0 0 KinnowWidth@ KinnowHeight@ "screen-bg" NVRAMGetVarNum KinnowRectangle

		0 KinnowNeedsInit!
	end
end

asm "

KinnowVsyncIntASM:
	pusha

	call KinnowVsyncInt

	popa
	iret

"

procedure KinnowVsyncAdd (* handler -- *)
	KinnowVsyncList@ ListInsert
end

procedure KinnowVsyncInt (* -- *)
	auto n
	KinnowVsyncList@ ListHead n!

	while (n@ 0 ~=)
		n@ ListNodeValue Call

		n@ ListNodeNext n!
	end
end

procedure KinnowVsyncOn (* -- *)
	auto rs
	InterruptDisable rs!

	pointerof KinnowVsyncIntASM KinnowSlot@ EBusSlotInterruptRegister

	KinnowGPUVsync KinnowCommand

	rs@ InterruptRestore
end

procedure KinnowScroll { x y w h color rows -- }
	auto rs
	InterruptDisable rs!

	auto cxy
	x@ 16 << y@ | cxy!

	auto cwh
	w@ 16 << h@ | cwh!

	auto crc
	rows@ 16 << color@ | crc!

	cxy@ KinnowOutPortA
	cwh@ KinnowOutPortB
	crc@ KinnowOutPortC

	KinnowGPUScroll KinnowCommand

	rs@ InterruptRestore
end

procedure KinnowRectangle { x y w h color -- }
	auto rs
	InterruptDisable rs!

	auto cxy
	x@ 16 << y@ | cxy!

	auto cwh
	w@ 16 << h@ | cwh!

	cxy@ KinnowOutPortA
	cwh@ KinnowOutPortB
	color@ KinnowOutPortC

	KinnowGPURectangle KinnowCommand

	rs@ InterruptRestore
end