# Pipes

A pipe is something one process writes to and another process
reads.  It has two ends: One end can be written to, the other end
can be read from.

yyi basic_pipe

The reader sees "EOF" if the sender (more precisely: *all*
senders) have closed the writing end of the pipe.

Behind the scenes, a pipe is an extremely fast I/O mechanism.  In
Linux, it is backed by a buffer of 65536 bytes (can be changed
for a particular pipe).  Don't know how big it is for Mac.

yyi fast_pipe

## Exercises

* Temporarily remove the closing of the pipe's write end from the
  reader in one of the sample programs.  What happens?

* Reorganize the program such that the sender is the child and
  the parent reads.  Let the parent close the reading end after
  reading 120000 bytes, while the child wants to write 200000
  bytes.  What happens?

* Devise a program that determines the buffer space provided by a
  pipe.  (Hint: Defer reading.  Measure the time required for
  writing.)
