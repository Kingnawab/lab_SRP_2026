# Level 3: return-to-function. Stack does NOT need to be executable.
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
