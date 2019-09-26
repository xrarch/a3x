SFILES := $(shell find . -type f -name '*.s')
OBJ    := ROMHeader.o Reset.o Serial.o POST.o Kinnow3.o Error.o End.o

AS       =  ../../../sdk/asm.sh
OBJTOOL  =  ../../../sdk/link.sh
LD       = $(OBJTOOL) link

all: llfw.bin

llfw.bin: $(OBJ)
	$(LD) llfw.bin $(OBJ)
	$(OBJTOOL) flatten llfw.bin 0xFFFE0000

%.o: %.s
	$(AS) $< $@

cleanup:
	rm *.bin
	rm *.o