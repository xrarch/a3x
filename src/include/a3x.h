#include "<inc>/list.h"
#include "<inc>/tree.h"
#include "<inc>/console.h"
#include "<inc>/devtree.h"
#include "<inc>/font.h"
#include "<inc>/nvram.h"
#include "<inc>/boot.h"
#include "<inc>/interrupt.h"
#include "<inc>/ebus.h"
#include "<inc>/pboard.h"
#include "<inc>/dma.h"
#include "<inc>/amanatsu.h"
#include "<inc>/citron.h"
#include "<inc>/platform.h"

extern Reset { -- }
extern LateReset { -- }

extern Monitor { -- }
extern DebugMonitor { state -- }

extern Problem { ... fmt -- }

externptr PlatformInited

const MEMORYFREE     1
const MEMORYRESERVED 2
const MEMORYBAD      3

// make sure to update link values if you change this
const FWSTART 0x4000
const FWEND   0x40000