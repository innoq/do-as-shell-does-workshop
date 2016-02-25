# Signals

provide an asynchronous trigger mechanism.

## Examples

There are many signals.  The more commonly encountered are:

num |   name   | description
----|----------|------------
  1 | **HUP**  | send to a process when the terminal is closed
  2 | **INT**  | interrupts a process (usually `^C`)
  9 | **KILL** | kills a process - no defense.
 11 | **SEGV** | process attempts to access non-existing memory
 13 | **PIPE** | attempt to write to a pipe without reader
  * | **USR1** | user-defined signal.
  * | **CONT** | Continues a process after stop.
  * | **STOP** | Stops a process (usually `^Z`)

A signal usually terminates the process.  Exceptions are **STOP**
and **CONT**.  The process can choose to react differently or
ignore most signals (exceptions: **STOP** and **KILL** are
handled by the operating system, the process never sees them).

Signal names may be preceded with a **SIG** without change of
meaning.  So **SIGHUP** and **HUP** are synonymous.

The signal numbers are valid only for Linux, they may be
different on Mac or other platforms.  Those marked with `*` are
different for Linux kernels running on different processor
architectures (Alpha, i386, MIPS).

The full list is available via `man 7 signal` on Linux, or in
Ruby via the following program:

yyi list_signals

## Sending signals

yyi basic_signal

## Handling signals

yyi catch_signal

## Exercise (not so important, if time permits)

* Read the manual pages of `nohup` and `dd`.

* Write a program that sends a `STOP` and later a `CONT` to its
  child.
