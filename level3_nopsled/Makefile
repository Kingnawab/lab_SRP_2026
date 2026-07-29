# CSE 29 Level 3 — NOP sled + injected shellcode (executable stack required).
#
# READ THE COMPILER WARNINGS. We do not silence them (-Wall -Wextra on).
#
#   -m32                 : 32-bit ELF on the course amd64 lab VM
#   -fno-stack-protector : no canaries
#   -z execstack         : allow NOP sled + shellcode on the stack
#   -no-pie -O0 -g

CC      = gcc
CFLAGS  = -m32 -Wall -Wextra -fno-stack-protector -z execstack -no-pie -O0 -g
TARGET  = vulnerable

.PHONY: all check clean

all: $(TARGET)

$(TARGET): vulnerable.c
	$(CC) $(CFLAGS) -o $(TARGET) vulnerable.c

check: $(TARGET)
	file $(TARGET)

clean:
	rm -f $(TARGET)
