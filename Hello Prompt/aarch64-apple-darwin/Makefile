.PHONY: run
run: main
	./main

.PHONY: test
test: main
	echo "foo" | ./main

.PHONY: dump
dump: main
	readelf --all $<

clean:
	$(RM) *.o
	$(RM) main

%.o: %.asm
	as -arch arm64 -o $@ $< --verbose -gdwarf-2

main: main.o
	ld -o $@ $< -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64 