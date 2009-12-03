GCC_FLAGS=-I/usr/include -I/usr/include/lua5.1
# GCC_FLAGS=-O0 -fno-inline -I/usr/include -I/usr/local/include/lua51

mixer.so: mixer.c
	gcc ${GCC_FLAGS} -c mixer.c && \
	gcc -o mixer.so -shared mixer.o && \
	strip mixer.so && \
	rm -f mixer.o

