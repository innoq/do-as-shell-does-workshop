# Stdin, Stdout, Stderr

A UNIX program has three "channels" open (can be pipes, files, a
terminal...).

## stdin

The place from which the program reads by default.

## stdout

The place to which the program writes by default.

## stderr

The place for human-consumable output and all things "logging".

## Discussion

This is the fundamental idea of the "pipes and filters"
architecture.

## Redirection with shell

In `bash` and similar shells:

`command1 | command2` creates a pipe and hooks up the writing end
to `stdout` of `command1` and the reading end to `stdin` of
`command2`.  (This is the prototypical filter pipeline.)

`command < file` redirects `stdin` from file.

`command < /dev/null` essentially closes `stdin` (any read will
return EOF).

`command > file` redirects `stdout` to file.

`command > /dev/null` ignores `stdout`.

`command 2> file` redirects `stderr` to file.

`command 2> /dev/null` ignores `stderr` *don't do that*.

`command1 2>&1` redirects `stderr` to add its stuff to wherever
`stdout` writes to.

## Beginner's mistake

It is bad style to put logging information or error messages to
`stdout` instead of `stderr`.

## Examples

If called with no argument, `gzip --verbose` compresses `stdin`
to `stdout` and gives some statistical information on `stderr`.

`od -c` converts binary data on `stdin` to some dump format
on `stdout`.

`grep blah` filters copies all lines from `stdin` to `stdout`
that contain the string `blah`, and ignores all other lines.

And so on, and so forth.

## Exercises

* Write a little script that writes "Hello, " to `stdout` and
  "world!" to `stderr`.

* To comply with the convention, where should your scripting
  language put information from any exception you might raise?
  Verify.

Up to 14:00 h.
