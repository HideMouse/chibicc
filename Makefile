CFLAGS=-std=c11 -g -fno-common -Wall -Wno-switch -Isrc

SRCS=$(wildcard ./src/*.c)
OBJS=$(patsubst ./src/%.c, ./build/%.o, $(SRCS))

# Compile Chibicc

chibicc: $(OBJS)
	@$(CC) $(CFLAGS) -o $@ $^

./build/%.o: ./src/%.c ./src/chibicc.h
	@$(CC) $(CFLAGS) -c -o $@ $<

# Hello :)

hello: hello.c chibicc
	./chibicc -Iinclude -as=gas  $< -o ./build/hello/hello.asm
	./chibicc -Iinclude -as=nasm $< -o ./build/hello/hello.nasm
	as ./build/hello/hello.asm -o ./build/hello/hello-gas.o
	nasm -f elf64 ./build/hello/hello.nasm -o ./build/hello/hello-nasm.o
	gcc ./build/hello/hello-gas.o -o hello-gas
	gcc ./build/hello/hello-nasm.o -o hello-nasm

# Misc.

clean:
	@rm -f build/*.o build/hello/hello* chibicc hello-*

.PHONY: clean hello
