# system

## Use `system`

### Demo

* Write a program `hello` that outputs
  something like "hello world".  Run it.

yyi hello

* Write another programm that calls your `hello` program via
  `system`.

yyi system_hello

### Demo: To shell or not to shell

yyi call_ps

## Exit values

> Happy families are all alike; every unhappy family is unhappy in its own way.

Leo Tolstoy, first sentence of "Anna Karenina".

### Demo ignoring exit values (don't do that!)

* Write a programm that fails (e.g., via exception).

yyi fail_via_exception

* Call it similar as above.

yyi system_fail_ignore

Notice: **The caller never notices anything is wrong.**

### Demo handling exit values

yyi system_fail_handle

### Demo analyzing exit values

You can set exit values as desired, in the range 0 .. 255:

yyi fail_via_exit

yyi system_fail_handle_detailed

## Exercise

Experiment with exit values.  Suggestions:

* Try calling `/bin/true` and `/bin/false`, if available on your system.

* What happens if you try to give an exit value outside the 0
  .. 255 range?

* What happens if you call a malformed script?  A non-existing
  script?  A directory instead of a script?

* Try calling `:`.

Up to 14:30 h.
