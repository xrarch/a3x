const DMABase              0xF0000000

const DMARegisterSource    0xF0000000
const DMARegisterDest      0xF0000004
const DMARegisterSInc      0xF0000008
const DMARegisterDInc      0xF000000C
const DMARegisterCount     0xF0000010
const DMARegisterMode      0xF0000014
const DMARegisterStatus    0xF0000018
const DMARegisterLines     0xF000001C
const DMARegisterDestMod   0xF0000020
const DMARegisterSrcMod    0xF0000024
const DMARegisterBitMode   0xF0000028
const DMARegisterSetByte   0xF000002C
const DMARegisterClearByte 0xF0000030
const DMARegisterDirection 0xF0000034

extern DMAWaitUnbusy { -- }

extern DMADoOperation { -- }

extern DMATransfer { src dest srcinc destinc count mode lines destmod srcmod -- }