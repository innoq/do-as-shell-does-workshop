# Fork and open files

## Prelude: Writing a file in ruby

yyinoout write

## What do you expect?

will be the content of `write_conflict.out` after this:

yyinoout write_conflict

It is:

```
I'm the parent, 24778.
I'm the child, 24780.
I'm the parent, 24778.
Child ok.
```

## WTF?

The call to `file.puts` does not actually write, but buffers.
The buffer gets copied by the `fork` and so gets written later.

To fix, `flush` the buffer.

If you absolutely want to, use `syswrite` (which does not buffer).
