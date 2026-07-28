# Build the Level 1 target.
# On the 32-bit (i686) course container, plain gcc already produces a
# 32-bit ELF. Protections are disabled so the stack matches the lecture model:
#   -fno-stack-protector : no stack canary
#   -no-pie              : fixed (non-relocatable) code/data addresses
#   -O0                 : no optimization, simple stack layout

CC      = gcc
CFLAGS  = -g -fno-stack-protector -no-pie -O0
TARGET  = vulnerable

$(TARGET): vulnerable.c
	$(CC) $(CFLAGS) -o $(TARGET) vulnerable.c

check: $(TARGET)
	file $(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: check clean
