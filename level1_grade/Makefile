# CSE 29 Level 1 — 32-bit ELF on the course lab VM (x86_64 Ubuntu + -m32).
#
# Flags (read the compiler output — we intentionally do NOT silence warnings):
#   -m32                 : 32-bit ELF (needs gcc-multilib / i386 libs on amd64)
#   -Wall -Wextra        : surface warnings students should learn to read
#   -fno-stack-protector : no stack canaries (overflows match lecture model)
#   -no-pie              : fixed load address (less address churn)
#   -O0                  : no optimization; simpler stack layout
#   -g                   : debug info for gdb
#
# Level 1 does NOT need -z execstack (no injected shellcode).

CC      = gcc
CFLAGS  = -m32 -Wall -Wextra -fno-stack-protector -no-pie -O0 -g
TARGET  = vulnerable

.PHONY: all check clean

all: $(TARGET)

$(TARGET): vulnerable.c
	$(CC) $(CFLAGS) -o $(TARGET) vulnerable.c

check: $(TARGET)
	file $(TARGET)

clean:
	rm -f $(TARGET)
