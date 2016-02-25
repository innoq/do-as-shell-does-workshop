---
title: exec
layout: section
previous_section: 03_fork.html
next_section: 05_fork_and_open_files.html
---
# exec

## Cease control

* **`exit`** cease to exist, either contentedly or grumbling.

* **`system`** cease control while some other process runs,
get back control when that other process is done.

* **`exec`** cease to exist, leaving a successor

File `04_exec/plain_exec.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

$stderr.puts "I am #{Process::pid} about to call exec."

# Replace this script with an invocation of ps:
exec 'ps', 'f', 'T'
# Use 'ps', '-j', '-T' on Mac

# This should never get executed:
raise "Exec did not work out."
{% endhighlight %}
Output is:

```
I am 1901 about to call exec.
  PID TTY      STAT   TIME COMMAND
 3240 pts/2    Ss     0:00 -bash
 1023 pts/2    Sl     0:03  \_ emacs 08_dup/
 1712 pts/2    Sl+    0:00  \_ ruby /home/andreask/.rvm/gems/ruby-2.3.0/bin/rake                                                              
 1901 pts/2    R+     0:00      \_ ps f T

```

Programm ran successfully.


## Often combined

File `04_exec/fork_exec_wait.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

$stderr.puts "#{Process::pid} about to fork and exec."

child_pid = fork

if child_pid.nil?
  exec 'ps', 'f', 'T'
  # Use 'ps', '-j', '-T' on Mac
  
  # This should never get executed:
  raise "Exec did not work out."
else
  Process::wait(child_pid)
  if not $?.success?
    raise "ERROR ps has #{$?.exitstatus}."
  end
end
{% endhighlight %}
Output is:

```
1905 about to fork and exec.
  PID TTY      STAT   TIME COMMAND
 3240 pts/2    Ss     0:00 -bash
 1023 pts/2    Sl     0:03  \_ emacs 08_dup/
 1712 pts/2    Sl+    0:00  \_ ruby /home/andreask/.rvm/gems/ruby-2.3.0/bin/rake                                                              
 1905 pts/2    Sl+    0:00      \_ ruby ./fork_exec_wait.rb
 1909 pts/2    R+     0:00          \_ ps f T

```

Programm ran successfully.


## Abbreviations

`fork` + `exec` = `spawn`

`fork` + `exec` + `wait` = `system`

That's true on UNIX (Linux, Mac).  But `spawn` and `system` may
be coded differently on other systems (Windows).  So those two
are generally more portable, they may exist on platforms that do
not provide `fork`.

## Exercise

* Run the fork_exec_wait - Example on your laptop.

* Port it to using `spawn`.
