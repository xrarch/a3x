DFILES := $(shell find . -type f -name '*.d')
OBJ    := $(DFILES:.d=.o)

LLFW   := llfw/llfw.bin

DC      =  ../../sdk/dragonc.sh
OBJTOOL = ../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: boot.bin

boot.bin: firmware.bin $(LLFW)
	cat $(LLFW) firmware.bin > boot.bin

$(LLFW):
	$(MAKE) --directory=llfw

firmware.bin: $(OBJ)
	$(LD) firmware.bin ./Antecedent.o $(OBJ) L/generic/lib.o
	$(OBJTOOL) flatten firmware.bin 0x2000
	printf '%s' `expr \`cat build\` + 1` > build

%.o: %.d
	$(DC) incdir=./include/ $< $@

cleanup:
	rm $(OBJ) firmware.bin boot.bin
	$(MAKE) --directory=llfw cleanup