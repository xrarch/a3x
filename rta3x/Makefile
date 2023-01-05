DFILES := $(shell find ./src -type f -name "*.df")
SFILES := $(shell find ./src -type f -name "*.s")
OBJ    := $(DFILES:.df=.o)
SOBJ   := $(SFILES:.s=.o)

DC  =  ../../sdk/dragonc.sh
AS  =  ../../sdk/asm.sh
LD  =  ../../sdk/link.sh link

all: obj/xr17032/cia3x.o obj/xr17032/rta3x.o obj/xr17032/_boot.o

obj/xr17032/cia3x.o: src/a3x.o
	mkdir -p obj/xr17032
	cp src/a3x.o obj/xr17032/cia3x.o

obj/xr17032/rta3x.o: $(OBJ) $(SOBJ)
	mkdir -p obj/xr17032
	$(LD) -f obj/xr17032/rta3x.o $(OBJ) $(SOBJ) L/dfrt/dfrt.f.o

obj/xr17032/_boot.o: ./client/_boot.s
	mkdir -p obj/xr17032
	$(AS) ./client/_boot.s obj/xr17032/_boot.o

%.o: %.df
	$(DC) $< $@ incdir=./headers/

%.o: %.s
	$(AS) $< $@

cleanup:
	rm -f $(OBJ) $(SOBJ) obj/*/*.o
