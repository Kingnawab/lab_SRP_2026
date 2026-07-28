# CSE 29 Level 2 — simple control-flow hijack (ret2win). No shellcode.
#
# READ THE COMPILER WARNINGS. We do not silence them (-Wall -Wextra on).

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
