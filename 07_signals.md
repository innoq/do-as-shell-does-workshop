---
title: signals
layout: section
previous_section: 06_pipes.html
next_section: 08_dup.html
---
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

File `07_signals/list_signals.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

Signal.list.each do |sig, num|
  puts "Signal #{num}: #{sig}."
end
{% endhighlight %}
Output is:

```
Signal 0: EXIT.
Signal 1: HUP.
Signal 2: INT.
Signal 3: QUIT.
Signal 4: ILL.
Signal 5: TRAP.
Signal 6: ABRT.
Signal 6: IOT.
Signal 8: FPE.
Signal 9: KILL.
Signal 7: BUS.
Signal 11: SEGV.
Signal 31: SYS.
Signal 13: PIPE.
Signal 14: ALRM.
Signal 15: TERM.
Signal 23: URG.
Signal 19: STOP.
Signal 20: TSTP.
Signal 18: CONT.
Signal 17: CHLD.
Signal 17: CLD.
Signal 21: TTIN.
Signal 22: TTOU.
Signal 29: IO.
Signal 24: XCPU.
Signal 25: XFSZ.
Signal 26: VTALRM.
Signal 27: PROF.
Signal 28: WINCH.
Signal 10: USR1.
Signal 12: USR2.
Signal 30: PWR.
Signal 29: POLL.

```

Programm ran successfully.


## Sending signals

File `07_signals/basic_signal.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

child_pid = fork

if child_pid.nil?
  # I am the child. I do nothing in particular.
  sleep 2
  exit 0
end

Process.kill 'INT', child_pid

Process.wait child_pid

if $?.success?
  $stderr.puts "Child exited successfully."
elsif $?.signaled?
  $stderr.puts "Child terminated by " +
               "#{Signal.signame($?.termsig)}."
else
  $stderr.puts "Child exit status #{$?.exitstatus}."
end
{% endhighlight %}
Output is:

```
./basic_signal.rb:7:in `sleep': Interrupt
	from ./basic_signal.rb:7:in `<main>'
Child terminated by INT.

```

Programm ran successfully.


## Handling signals

File `07_signals/catch_signal.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

child_pid = fork

if child_pid.nil?
  # I am the child. I do nothing in particular.
  Signal.trap 'INT' do
    $stderr.puts "I'm a child " +
                 "unwilling to be interrupted."
  end
  sleep 2
  exit 0
end

sleep 0.1 # Give the child time to run the Signal.trap.
Process.kill 'SIGINT', child_pid

Process.wait child_pid

if $?.success?
  $stderr.puts "Child exited successfully."
elsif $?.signaled?
  $stderr.puts "Child terminated by signal " +
               "#{Signal.signame($?.termsig)}."
else
  $stderr.puts "Child exit status #{$?.exitstatus}."
end
{% endhighlight %}
Output is:

```
I'm a child unwilling to be interrupted.
Child exited successfully.

```

Programm ran successfully.


## Exercise (not so important, if time permits)

* Read the manual pages of `nohup` and `dd`.

* Write a program that sends a `STOP` and later a `CONT` to its
  child.
