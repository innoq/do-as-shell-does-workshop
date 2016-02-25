---
title: fork
layout: section
previous_section: 02_system_and_exit_values.html
next_section: 04_exec.html
---
# fork

What fork is about:

File `03_fork/first_fork.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

$stderr.puts "I'm #{Process::pid}."

child_pid = fork

$stderr.puts "I have #{child_pid.inspect} " +
             "and I'm #{Process::pid}."
{% endhighlight %}
Output is:

```
I'm 1762.
I have 1767 and I'm 1762.
I have nil and I'm 1767.

```

Programm ran successfully.


Parent can retrieve the exit status of child:

File `03_fork/basic_fork.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

$stderr.puts "I'm #{Process::pid}."

child_pid = fork
$stderr.puts "#{Process::pid} has #{child_pid.inspect}"

if child_pid.nil?
  # I'm the child
  $stderr.puts "#{Process::pid} about to exit 39."
  exit 39
else
  # I'm the parent
  $stderr.puts "#{Process::pid} waits for #{child_pid}"
  Process::wait child_pid
  
  $stderr.puts "#{Process::pid} reaped #{child_pid}:" +
               " #{$?.pid} has #{$?.exitstatus}."
end
{% endhighlight %}
Output is:

```
I'm 1770.
1770 has 1774
1770 waits for 1774
1774 has nil
1774 about to exit 39.
1770 reaped 1774: 1774 has 39.

```

Programm ran successfully.


## Many forks...

You can do many forks.

File `03_fork/many_forks_flat.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

children_pids = []

wanted_fork_count = 20

# On my laptop, one fork takes a little less than 1 ms,
# when this script does a lot of them.
# Sleep long enough, so the firstly-created processes
# are likely to still sleep
# while the last process is created.
# (Strictly speaking, this is a race condition.)
sleep_time = 1 + wanted_fork_count * 0.0015
$stderr.puts "Sleep time is #{sleep_time} s."

while 2 <= wanted_fork_count
  child_pid = fork
  if child_pid.nil?
    if 2 == wanted_fork_count
      # Of the 2 processes,
      # one is the new child executing this,
      # the other one is this:
      system 'ps', 'f', 'T' or raise "Couldn't ps"
    else
      sleep sleep_time
    end
    # Mental exercise:
    # What happens when you forget the following line?
    exit 0
  else
    # I'm the parent
    # Remember the child pid,
    # to collect the exit status later:
    children_pids << child_pid
    # One fork less I still need to do:
    wanted_fork_count -= 1
  end
end

all_well = true

children_pids.each do |child_pid|
  Process::wait child_pid
  if not $?.success?
    $stderr.puts "ERROR #{$?.pid} with {$?.exitstatus}"
    all_well = false
  end
end

raise "Problem with at least one child." unless all_well
{% endhighlight %}
Output is:

```
Sleep time is 1.03 s.
  PID TTY      STAT   TIME COMMAND
 3240 pts/2    Ss     0:00 -bash
 1023 pts/2    Sl     0:03  \_ emacs 08_dup/
 1712 pts/2    Sl+    0:00  \_ ruby /home/andreask/.rvm/gems/ruby-2.3.0/bin/rake                                                              
 1777 pts/2    Sl+    0:00      \_ ruby ./many_forks_flat.rb
 1781 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1784 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1787 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1790 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1793 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1796 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1799 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1802 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1805 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1808 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1811 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1814 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1817 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1820 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1823 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1826 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1829 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1832 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1835 pts/2    Sl+    0:00          \_ ruby ./many_forks_flat.rb
 1838 pts/2    R+     0:00              \_ ps f T

```

Programm ran successfully.


There are 2^16 = 65536 process ids in Linux, which presents an
upper limit.  Several thousands is no problem for Linux.  But it
may be for you...

## A word of warning

The Linux kernel dutifully distributes CPU attention *evenly*
among processes that have work to do.

If you have several thousands of those, your UI session is just
one or a few among these many, so it receives only a very tiny
fraction of CPU attention.

Your laptop becomes utterly unresponsive:

**Too many active processes make your system unusable.**

Plan A, ahead of time: Increase niceness.

Plan B, after the fact: Reboot forcefully.

File `03_fork/many_forks_flat_nice.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

oldnice = Process.getpriority(Process::PRIO_PROCESS,0)

# Set prio to "19",
# meaning, "run me only if nothing else wants to run".
Process.setpriority(Process::PRIO_PROCESS,0,19)


newnice = Process.getpriority(Process::PRIO_PROCESS,0)
$stderr.puts "Nice from #{oldnice} to #{newnice}."

# Now same as we had:

load 'many_forks_flat.rb'
{% endhighlight %}
Output is:

```
Nice from 0 to 19.
Sleep time is 1.03 s.
  PID TTY      STAT   TIME COMMAND
 3240 pts/2    Ss     0:00 -bash
 1023 pts/2    Sl     0:03  \_ emacs 08_dup/
 1712 pts/2    Sl+    0:00  \_ ruby /home/andreask/.rvm/gems/ruby-2.3.0/bin/rake                                                              
 1839 pts/2    SNl+   0:00      \_ ruby ./many_forks_flat_nice.rb
 1843 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1846 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1849 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1852 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1855 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1858 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1861 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1864 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1867 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1870 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1873 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1876 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1879 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1882 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1885 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1888 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1891 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1894 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1897 pts/2    SNl+   0:00          \_ ruby ./many_forks_flat_nice.rb
 1900 pts/2    RN+    0:00              \_ ps f T

```

Programm ran successfully.


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
