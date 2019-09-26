const AmaPortDev 0x30
const AmaPortMID 0x31
const AmaPortCMD 0x32
const AmaPortA 0x33
const AmaPortB 0x34

extern AmanatsuPoll (* num -- mid *)

extern AmanatsuSelectDev (* num -- *)

extern AmanatsuReadMID (* -- mid *)

extern AmanatsuCommand (* cmd -- *)

extern AmanatsuCommandAsync (* cmd -- *)

extern AmanatsuWriteA (* long -- *)

extern AmanatsuWriteB (* long -- *)

extern AmanatsuReadA (* -- long *)

extern AmanatsuReadB (* -- long *)

extern AmanatsuDevFromInt (* int -- dev *)

extern AmanatsuSetInterrupt (* handler dev -- *)

extern AmanatsuSpecialCMD (* a b cmd -- *)