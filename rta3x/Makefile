DFILES := $(shell find ./src -type f -name '*.df')
SFILES := $(shell find ./src -type f -name '*.s')
OBJ    := $(DFILES:.df=.o)
SOBJ   := $(SFILES:.s=.o)

DC  =  ../../sdk/dragonc.sh
AS  =  ../../sdk/asm.sh
LD  =  ../../sdk/link.sh link

all: obj/rta3x.o obj/_boot.o

obj/rta3x.o: $(OBJ) $(SOBJ)
	$(LD) -f obj/rta3x.o L/dfrt/dfrt.f.o $(OBJ) $(SOBJ)

obj/_boot.o: ./client/_boot.s
	$(AS) ./client/_boot.s obj/_boot.o

%.o: %.df
	$(DC) $< $@ incdir=./headers/

%.o: %.s
	$(AS) $< $@

cleanup:
	rm $(OBJ) $(SOBJ) obj/rta3x.o