---
title: system_and_exit_values
layout: section
previous_section: 01_std.html
next_section: 03_fork.html
---
# system

## Use `system`

### Demo

* Write a program `hello` that outputs
  something like "hello world".  Run it.

File `02_system_and_exit_values/hello.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

$stderr.puts "Hello, World. I am process #{Process::pid}."
{% endhighlight %}
Output is:

```
Hello, World. I am process 1714.

```

Programm ran successfully.


* Write another programm that calls your `hello` program via
  `system`.

File `02_system_and_exit_values/system_hello.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

$stderr.puts "#{Process::pid} calls ./hello.rb."

system('./hello.rb')

$stderr.puts "Back in #{Process::pid}."



{% endhighlight %}
Output is:

```
1718 calls ./hello.rb.
Hello, World. I am process 1722.
Back in 1718.

```

Programm ran successfully.


### Demo: To shell or not to shell

File `02_system_and_exit_values/call_ps.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

puts "First call from process #{Process::pid}"

system 'ps', 'f', 'T'

puts "\nSecond call from process #{Process::pid}"

system "ps f T"

puts "\nThird call from process #{Process::pid}"

system "ps f 'T'"
{% endhighlight %}
Output is:

```
First call from process 1724
  PID TTY      STAT   TIME COMMAND
 3240 pts/2    Ss     0:00 -bash
 1023 pts/2    Sl     0:03  \_ emacs 08_dup/
 1712 pts/2    Sl+    0:00  \_ ruby /home/andreask/.rvm/gems/ruby-2.3.0/bin/rake                                                              
 1724 pts/2    Sl+    0:00      \_ ruby ./call_ps.rb
 1728 pts/2    R+     0:00          \_ ps f T

Second call from process 1724
  PID TTY      STAT   TIME COMMAND
 3240 pts/2    Ss     0:00 -bash
 1023 pts/2    Sl     0:03  \_ emacs 08_dup/
 1712 pts/2    Sl+    0:00  \_ ruby /home/andreask/.rvm/gems/ruby-2.3.0/bin/rake                                                              
 1724 pts/2    Sl+    0:00      \_ ruby ./call_ps.rb
 1729 pts/2    R+     0:00          \_ ps f T

Third call from process 1724
  PID TTY      STAT   TIME COMMAND
 3240 pts/2    Ss     0:00 -bash
 1023 pts/2    Sl     0:03  \_ emacs 08_dup/
 1712 pts/2    Sl+    0:00  \_ ruby /home/andreask/.rvm/gems/ruby-2.3.0/bin/rake                                                              
 1724 pts/2    Sl+    0:00      \_ ruby ./call_ps.rb
 1730 pts/2    S+     0:00          \_ sh -c ps f 'T'
 1731 pts/2    R+     0:00              \_ ps f T

```

Programm ran successfully.


## Exit values

> Happy families are all alike; every unhappy family is unhappy in its own way.

Leo Tolstoy, first sentence of "Anna Karenina".

### Demo ignoring exit values (don't do that!)

* Write a programm that fails (e.g., via exception).

File `02_system_and_exit_values/fail_via_exception.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

raise "#{Process::pid} fails."
{% endhighlight %}
Output is:

```
./fail_via_exception.rb:3:in `<main>': 1732 fails. (RuntimeError)

```

Programm **failed** with status 1.


* Call it similar as above.

File `02_system_and_exit_values/system_fail_ignore.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

$stderr.puts "About to call, says #{Process::pid}."

system('./fail_via_exception.rb')

$stderr.puts "Done calling."



{% endhighlight %}
Output is:

```
About to call, says 1736.
./fail_via_exception.rb:3:in `<main>': 1740 fails. (RuntimeError)
Done calling.

```

Programm ran successfully.


Notice: **The caller never notices anything is wrong.**

### Demo handling exit values

File `02_system_and_exit_values/system_fail_handle.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

$stderr.puts "About to call from #{Process::pid}."

system('./fail_via_exception.rb') or \
  raise "ERROR in system"

$stderr.puts "Done calling."

{% endhighlight %}
Output is:

```
About to call from 1742.
./fail_via_exception.rb:3:in `<main>': 1746 fails. (RuntimeError)
./system_fail_handle.rb:6:in `<main>': ERROR in system (RuntimeError)

```

Programm **failed** with status 1.


### Demo analyzing exit values

You can set exit values as desired, in the range 0 .. 255:

File `02_system_and_exit_values/fail_via_exit.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

$stderr.puts "#{Process::pid} fails with 200."

exit(200)
{% endhighlight %}
Output is:

```
1751 fails with 200.

```

Programm **failed** with status 200.


File `02_system_and_exit_values/system_fail_handle_detailed.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

$stderr.puts "About to call, says upper #{Process::pid}."

system('./fail_via_exit.rb')

$stderr.puts "Done calling, $? is now \"#{$?.inspect}\", says upper #{Process::pid}."

# See http://ruby-doc.org/core-2.2.3/Process/Status.html ...

if $?.success?
  $stderr.puts "Down #{$?.pid} was happy, exit status is (of course) #{$?.exitstatus}."
elsif $?.signaled?
  $stderr.puts "Down #{$?.pid} received signal \"#{$?.termsig}\"."
else
  $stderr.puts "Down #{$?.pid} has exit status #{$?.exitstatus}."
end



{% endhighlight %}
Output is:

```
About to call, says upper 1755.
1760 fails with 200.
Done calling, $? is now "#<Process::Status: pid 1760 exit 200>", says upper 1755.
Down 1760 has exit status 200.

```

Programm ran successfully.


## Exercise

Experiment with exit values.  Suggestions:

* Try calling `/bin/true` and `/bin/false`, if available on your system.

* What happens if you try to give an exit value outside the 0
  .. 255 range?

* What happens if you call a malformed script?  A non-existing
  script?  A directory instead of a script?

* Try calling `:`.
