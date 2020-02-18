DFILES := $(shell find . -type f -name '*.df')
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

firmware.bin: $(OBJ) pec/PECInterpret.o
	$(LD) firmware.bin ./Antecedent.o $(OBJ) pec/PECInterpret.o L/libsa/lib.o
	$(OBJTOOL) flatten firmware.bin 0x2000
	printf '%s' `expr \`cat build\` + 1` > build

pec/PECInterpret.o: pec/PECInterpret.s
	$(AS) pec/PECInterpret.s pec/PECInterpret.o

%.o: %.df
	$(DC) incdir=./include/ $< $@

cleanup:
	rm $(OBJ) firmware.bin boot.bin
	$(MAKE) --directory=llfw cleanup