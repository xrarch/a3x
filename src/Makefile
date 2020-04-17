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

firmware.bin: $(OBJ) auc/AUCInterpret.o
	$(LD) firmware.bin ./Antecedent.o $(OBJ) auc/AUCInterpret.o L/dfrt/dfrt.f.o
	$(OBJTOOL) move firmware.bin text=0x2000,data=text+text_size,bss=data+data_size
	cp firmware.bin a3x.LOFF
	$(OBJTOOL) binary firmware.bin
	printf '%s' `expr \`cat build\` + 1` > build

auc/AUCInterpret.o: auc/AUCInterpret.s
	$(AS) auc/AUCInterpret.s auc/AUCInterpret.o

%.o: %.df
	$(DC) incdir=./include/ $< $@

cleanup:
	rm $(OBJ) firmware.bin boot.bin auc/AUCInterpret.o
	$(MAKE) --directory=llfw cleanup
