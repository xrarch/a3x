const EBusSlotsStart 0xC0000000
const EBusSlots 7
const EBusSlotSpace 0x8000000
const EBusBoardMagic 0x0C007CA1

extern EBusFindFirstBoard (* id -- slot *)

extern EBusSlotInterruptRegister (* handler slot -- *)