const DMARegisterSource 0x38000000
const DMARegisterDest 0x38000004
const DMARegisterSInc 0x38000008
const DMARegisterDInc 0x3800000C
const DMARegisterCount 0x38000010
const DMARegisterMode 0x38000014
const DMARegisterStatus 0x38000018

extern DMAWaitUnbusy (* -- *)

extern DMADoOperation (* -- *)

extern DMATransfer (* src dest srcinc destinc count mode -- *)