DFILES := $(shell find ./src -type f -name "*.df")
SFILES := $(shell find ./src -type f -name "*.s")
OBJ    := $(DFILES:.df=.o)
SOBJ   := $(SFILES:.s=.o)

DC  =  ../../sdk/dragonc.sh
AS  =  ../../sdk/asm.sh
LD  =  ../../sdk/link.sh link

all: obj/cia3x.o obj/rta3x.o obj/_boot.o

obj/cia3x.o: src/a3x.o
	mkdir -p obj
	cp src/a3x.o obj/cia3x.o

obj/rta3x.o: $(OBJ) $(SOBJ)
	mkdir -p obj
	$(LD) -f obj/rta3x.o L/dfrt/dfrt.f.o $(OBJ) $(SOBJ)

obj/_boot.o: ./client/_boot.s
	mkdir -p obj
	$(AS) ./client/_boot.s obj/_boot.o

%.o: %.df
	$(DC) $< $@ incdir=./headers/

%.o: %.s
	$(AS) $< $@

cleanup:
	rm -f $(OBJ) $(SOBJ) obj/rta3x.o obj/_boot.o
