struct TrapFrame
	4 lr
	4 ers
	4 epc

	4 r1    4 r2
	4 r3    4 r4
	4 r5    4 r6
	4 r7    4 r8
	4 r9    4 r10
	4 r11   4 r12
	4 r13   4 r14
	4 r15   4 r16
	4 r17   4 r18
	4 r19   4 r20
	4 r21   4 r22
	4 r23   4 r24
	4 r25   4 r26
	4 at    4 tf
endstruct

table TrapFrame_Names
	"lr"
	"ers"
	"epc"

	"t0"    "t1"
	"t2"    "t3"
	"t4"    "a0"
	"a1"    "a2"
	"a3"    "v0"
	"v1"    "s0"
	"s1"    "s2"
	"s3"    "s4"
	"s5"    "s6"
	"s7"    "s7"
	"s9"    "s10"
	"s11"   "s12"
	"s13"   "s14"
	"at"    "tf"
endtable

const TrapFrameNElem 31