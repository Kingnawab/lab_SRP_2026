# Level 2: executable stack required so injected shellcode can run.
#   -z execstack : mark stack executable (disable NX for this lab)

CC      = gcc
CFLAGS  = -g -fno-stack-protector -no-pie -O0 -z execstack
TARGET  = vulnerable

$(TARGET): vulnerable.c
	$(CC) $(CFLAGS) -o $(TARGET) vulnerable.c

check: $(TARGET)
	file $(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: check clean
