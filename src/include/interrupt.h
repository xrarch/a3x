extern InterruptRegister { handler num -- }

extern InterruptUnregister { num -- }

extern InterruptEnable { -- }

extern InterruptDisable { -- rs }

extern InterruptRestore { rs -- }

externptr BusErrorExpected
externptr BusErrorOccurred