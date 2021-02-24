SFILES := $(shell find . -type f -name "*.s")
OBJ    := ROMHeader.o Copy.o Exception.o Serial.o Error.o POST.o LoadBIOS.o Framebuffer.o Reset.o

AS       =  ../../../sdk/asm.sh
OBJTOOL  =  ../../../sdk/link.sh
LD       = $(OBJTOOL) link

all: llfw.bin

llfw.bin: $(OBJ)
	$(LD) llfw.bin $(OBJ)
	$(OBJTOOL) move llfw.bin text=0xFFFE0000,data=text+text_size,bss=0x400
	cp llfw.bin llfw.LOFF
	$(OBJTOOL) binary -nobss llfw.bin

%.o: %.s
	$(AS) $< $@

cleanup:
	rm -f *.LOFF *.bin *.o
