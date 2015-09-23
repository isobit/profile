# Author: Josh Glendenning
CC=c++
CFLAGS=-O3
MAIN=main

all: main

main: $(MAIN).cpp
	$(CC) $(CFLAGS) $(MAIN).cpp -o $(MAIN)

test: main
	./$(MAIN)

clean:
	-rm -f $(MAIN)
	-rm -f *.o
	-rm -rf *.dSYM

