const DMABase              0x38000000

const DMARegisterSource    0x38000000
const DMARegisterDest      0x38000004
const DMARegisterSInc      0x38000008
const DMARegisterDInc      0x3800000C
const DMARegisterCount     0x38000010
const DMARegisterMode      0x38000014
const DMARegisterStatus    0x38000018
const DMARegisterLines     0x3800001C
const DMARegisterDestMod   0x38000020
const DMARegisterSrcMod    0x38000024
const DMARegisterBitMode   0x38000028
const DMARegisterSetByte   0x3800002C
const DMARegisterClearByte 0x38000030
const DMARegisterDirection 0x38000034

extern DMAWaitUnbusy { -- }

extern DMADoOperation { -- }

extern DMATransfer { src dest srcinc destinc count mode lines destmod srcmod -- }