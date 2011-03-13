GCC_FLAGS=-I/usr/include -I/usr/include/lua5.1
# GCC_FLAGS=-O0 -fno-inline -I/usr/include -I/usr/local/include/lua51

mixer.so: mixer.c
	gcc ${GCC_FLAGS} -c mixer.c && \
	gcc -o mixer.so -shared mixer.o && \
	strip mixer.so && \
	rm -f mixer.o

statfs.so: statfs.c
	gcc ${GCC_FLAGS} -c statfs.c && \
	gcc -o statfs.so -shared statfs.o && \
	strip statfs.so && \
	rm -f statfs.o

mixer4.so: mixer4.c
	gcc -I/usr/lib/oss/include ${GCC_FLAGS} -c mixer4.c && \
	gcc -o mixer4.so -shared mixer4.o && \
	strip mixer4.so
