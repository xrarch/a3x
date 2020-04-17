SFILES := $(shell find . -type f -name '*.s')
OBJ    := ROMHeader.o Reset.o Serial.o POST.o Kinnow3.o Error.o End.o

AS       =  ../../../sdk/asm.sh
OBJTOOL  =  ../../../sdk/link.sh
LD       = $(OBJTOOL) link

all: llfw.bin

llfw.bin: $(OBJ)
	$(LD) llfw.bin $(OBJ)
	$(OBJTOOL) move llfw.bin text=0xFFFE0000,data=text+text_size,bss=data+data_size
	cp llfw.bin llfw.LOFF
	$(OBJTOOL) binary llfw.bin

%.o: %.s
	$(AS) $< $@

cleanup:
	rm *.bin
	rm *.o
