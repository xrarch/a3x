struct TrapFrame
	4 lr
	4 ers
	4 epc

	4 t0    4 t1
	4 t2    4 t3
	4 t4    4 a0
	4 a1    4 a2
	4 a3    4 v0
	4 v1    4 s0
	4 s1    4 s2
	4 s3    4 s4
	4 s5    4 s6
	4 s7    4 s8
	4 s9    4 s10
	4 s11   4 r12
	4 s13   4 s14
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