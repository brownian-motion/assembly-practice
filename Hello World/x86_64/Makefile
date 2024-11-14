.PHONY: run
run: hello_world
	./hello_world

clean:
	rm *.o
	rm hello_world

%.o: %.asm
	nasm -f elf64 -g -F DWARF $<

hello_world: hello_world.o
	ld -e start -o $@ $<