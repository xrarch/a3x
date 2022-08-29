DFILES := $(shell find ./src -type f -name "*.df")
SFILES := $(shell find ./src -type f -name "*.s")
OBJ    := $(DFILES:.df=.o)
SOBJ   := $(SFILES:.s=.o)

DC  =  ../../sdk/dragonc.sh
AS  =  ../../sdk/asm.sh
LD  =  ../../sdk/link.sh link

all: obj/limn2600/cia3x.o obj/limn2600/rta3x.o obj/limn2600/_boot.o

obj/limn2600/cia3x.o: src/a3x.o
	mkdir -p obj/limn2600
	cp src/a3x.o obj/limn2600/cia3x.o

obj/limn2600/rta3x.o: $(OBJ) $(SOBJ)
	mkdir -p obj/limn2600
	$(LD) -f obj/limn2600/rta3x.o $(OBJ) $(SOBJ) L/dfrt/dfrt.f.o

obj/limn2600/_boot.o: ./client/_boot.s
	mkdir -p obj/limn2600
	$(AS) ./client/_boot.s obj/limn2600/_boot.o

%.o: %.df
	$(DC) $< $@ incdir=./headers/

%.o: %.s
	$(AS) $< $@

cleanup:
	rm -f $(OBJ) $(SOBJ) obj/*/*.o
