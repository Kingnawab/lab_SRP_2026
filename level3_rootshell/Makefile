# CSE 29 Level 3 — return-to-function on a native 32-bit (i386) Linux VM.
#
# Guest OS should already be 32-bit, so plain gcc produces an i386 ELF.
#
# Flags (read the compiler output — we intentionally do NOT silence warnings):
#   -Wall -Wextra        : surface warnings students should learn to read
#   -fno-stack-protector : no stack canaries
#   -no-pie              : fixed load address (easy to find root_shell)
#   -O0                  : simpler stack layout
#   -g                   : debug info for gdb
#
# Level 3 does NOT need -z execstack — you jump to existing code, not the stack.

CC      = gcc
CFLAGS  = -Wall -Wextra -fno-stack-protector -no-pie -O0 -g
TARGET  = vulnerable

.PHONY: all check clean

all: $(TARGET)

$(TARGET): vulnerable.c
	$(CC) $(CFLAGS) -o $(TARGET) vulnerable.c

check: $(TARGET)
	file $(TARGET)

clean:
	rm -f $(TARGET)
