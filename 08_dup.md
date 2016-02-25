---
title: dup
layout: section
previous_section: 07_signals.html
---
# Dup (aka "reopen")

The missing piece: How to connect a pipe to either `stdin` or `stdout`?

This is the system call `dup2`, see `man 2 dup2`.  In Ruby, this is called [`reopen`](http://ruby-doc.org/core-2.2.3/IO.html#method-i-reopen).

## Example

File `08_dup/basic_dup.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

readMe, writeMe = IO.pipe

child_pid = fork

if child_pid.nil?
  $stderr.puts "Child is at #{Process.pid}"

  writeMe.close

  # Close $stdin, and reopen it to be a copy of readMe:
  $stdin.reopen(readMe) # The system call is dup2.

  # One is enough:
  readMe.close

  # Now whatever the parent writes to its end of the pipe
  # becomes the input of our process.

  # Dump that input:
  exec 'od', '-c'
end

readMe.close
writeMe.puts "\0\t\nhello\vworld.\n"
writeMe.close

Process.wait child_pid
raise "od had a problem" unless $?.success?
{% endhighlight %}
Output is:

```
Child is at 1948
0000000  \0  \t  \n   h   e   l   l   o  \v   w   o   r   l   d   .  \n
0000020

```

Programm ran successfully.


## Exercise

To produce some output, this program counts to `stdout`:

File `08_dup/count_to_1m.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

(1..1000000).each do |i|
  $stdout.write("#{i}\n")
end
{% endhighlight %}

This program copies everything from `stdin` to `stdout`, with the
exception of the 20001st byte, which is deviously changed
slightly:

File `08_dup/distort_after_20k.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

# copy 20000 byte,
# then change one byte,
# then copy the rest.

if (buf = $stdin.read(20000))
  $stdout.write buf
  if c = $stdin.getbyte
    $stdout.putc(c ^ 3)
    while buf = $stdin.read(2 ** 16)
      $stdout.write buf
    end
  end
end
{% endhighlight %}

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
