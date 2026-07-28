# CSE 29 Level 1 — build on a native 32-bit (i386) Linux VM.
#
# Guest OS should already be 32-bit, so plain gcc produces an i386 ELF
# (no -m32 / multilib needed).
#
# Flags (read the compiler output — we intentionally do NOT silence warnings):
#   -Wall -Wextra        : surface warnings students should learn to read
#   -fno-stack-protector : no stack canaries (overflows match lecture model)
#   -no-pie              : fixed load address (less address churn)
#   -O0                  : no optimization; simpler stack layout
#   -g                   : debug info for gdb
#
# Level 1 does NOT need -z execstack (no injected shellcode).

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
