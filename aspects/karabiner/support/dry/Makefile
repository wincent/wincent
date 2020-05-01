PREFIX ?= $(HOME)
CFLAGS := -ansi -pedantic -Wall -Wextra ${CFLAGS}

dry: main.c
	${CC} ${CFLAGS} \
		-framework CoreFoundation \
		-framework CoreServices \
		-framework IOKit \
		-o dry main.c

install:
	install -m755 dry ${PREFIX}/bin
