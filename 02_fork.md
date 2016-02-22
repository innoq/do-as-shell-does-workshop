# fork

What fork is about:

yyi first_fork

Parent can retrieve the exit status of child:

yyi basic_fork

## Many forks...

You can do many forks.

There are 2^16 = 65536 process ids in Linux, which presents an
upper limit.  Several thousands is no problem.

yyi many_forks_flat

## ...and a word of warning

The Linux kernel dutifully distributes CPU attention *evenly*
among processes that have work to do.

Leaving next to nothing for your UI session.

(If those UI processes are not distinguished among the thousands
of processes demanding CPU attention.)

**Too many active processes make your system unusable.**

Plan A, ahead of time: Increase niceness.

Plan B, after the fact: Reboot forcefully.

yyi many_forks_flat_nice

### Exercise: UNIX orphanage

* Create a program that prints its pid and then forks,

* then the parent simply exits immediately
  without waiting for the child,

* while child waits for a little while (so the parent is surely gone)
  and then calls `ps f l T` (or `ps -j -T` on Mac).

What do you see?

### Exercise: How nice is nice enough?

Experiment a bit, e.g.:

* Is your system responsive when some 10000 processes do
  something simultaneously (even if all they do is `exit 0`)
  without nice-value (that is, with the default nice-value 0)?

* With nice-value 19?

* How low can you move the nice-value without seeing sluggishness?
  (On my system, with the flat program, a nice-value 11, a parallel-running 
  `xclock -update 1 -norender` is visually sluggish, but no longer so with 12).

### Exercise: Dual layer fork

* Create a program that forks 3 copies of itself, each of which
again forks 3 copies of itself.

* The original program and the intermediate forks simply collect
their children, check their exit value, and exit themselves.

* The last of all the lower level runs `ps f T` (or `ps -j -T` on
Mac) to prove it, all others sleep 1 second.

Change your program so that 100 copies are done at each state,
leading to a total of 10000 processes.  Let them sleep for 15
seconds.
