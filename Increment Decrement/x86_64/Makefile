.PHONY: run
run: main
	./main

.PHONY: test
test: main
	echo "3" | ./main

.PHONY: dump
dump: main
	readelf --all $<

clean:
	rm *.o
	rm main

%.o: %.asm
	nasm -f elf64 -g -F DWARF $<

main: main.o
	ld -e _start -o $@ $<