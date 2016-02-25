# Dup (aka "reopen")

The missing piece: How to connect a pipe to either `stdin` or `stdout`?

This is the system call `dup2`, see `man 2 dup2`.  In Ruby, this is called [`reopen`](http://ruby-doc.org/core-2.2.3/IO.html#method-i-reopen).

## Example

yyi basic_dup

## Exercise

To produce some output, this program counts to `stdout`:

yyinoout count_to_1m

This program copies everything from `stdin` to `stdout`, with the
exception of the 20001st byte, which is deviously changed
slightly:

yyinoout distort_after_20k

Now, consider the pipeline

    ./count_to_1m.rb | gzip | ./distort_after_20k.rb | zcat | wc

(You can use other packers such as `bzip2` or `xz`.)

It produces the output:

```
gzip: stdin: invalid compressed data--crc error
1000000 1000000 6888896
```

The `zcat` clearly knows there is a problem, **but the pipeline
as a whole succeeds**.  The `wc` gets wrong input.

Replace this shell pipeline with a driver script that fails
cleanly if any of the constituents fail (not just the last, as
the shell does).

## Remarks

I recommended `spawn` and `system` earlier.  It is possible to
supply them with IO-reopen information, often making it
unnecessary to call `pipe` and `reopen`.

There is also a convenience function `popen` that makes it easy
to do IO to and from some command.

## Suggested research

Have a look into

* Non-blocking IO

* Inetd

Up to 16:30 h.
