.PHONY: run
run: hello_world
	./hello_world

clean:
	rm *.o
	rm hello_world

%.o: %.asm
	as -arch arm64 -o $@ $<

hello_world: hello_world.o
	ld -o $@ $< -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64 