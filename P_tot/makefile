GSLINC = /opt/local/include
GSLLIB = /opt/local/lib

emu.exe: main.o emu.o
	gcc -L$(GSLLIB) -I$(GSLINC) -o $@ $^ -lgsl -lgslcblas -lm

emu.o: emu.c
	gcc -std=c99 -I$(GSLINC) -c -o $@ $<

main.o: main.c
	gcc -std=c99 -I$(GSLINC) -c -o $@ $<

clean:
	/bin/rm -f *.o