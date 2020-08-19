DFILES := $(shell find . -type f -name "*.df")
OBJ    := $(DFILES:.df=.o)

LLFW   := llfw/llfw.bin

AS      =  ../../sdk/asm.sh
DC      =  ../../sdk/dragonc.sh
OBJTOOL = ../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: boot.bin

boot.bin: firmware.bin $(LLFW)
	cat $(LLFW) firmware.bin > boot.bin

$(LLFW):
	$(MAKE) --directory=llfw

firmware.bin: $(OBJ)
	$(LD) firmware.bin $(OBJ) L/dfrt/dfrt.f.o
	$(OBJTOOL) move firmware.bin text=0x2000,data=text+text_size,bss=data+data_size
	cp firmware.bin a3x.LOFF
	$(OBJTOOL) strip firmware.bin
	printf '%s' `expr \`cat build\` + 1` > build

%.o: %.df
	$(DC) incdir=./include/ $< $@

cleanup:
	rm -f $(OBJ) a3x.LOFF firmware.bin boot.bin
	$(MAKE) --directory=llfw cleanup
