---
title: fork_and_open_files
layout: section
previous_section: 04_exec.html
next_section: 06_pipes.html
---
# Fork and open files

## Prelude: Writing a file in ruby

File `05_fork_and_open_files/write.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

File.open "write.out", "w" do |file|
  file.puts "I am process #{Process::pid}."
end
{% endhighlight %}

## What do you expect?

will be the content of `write_conflict.out` after this:

File `05_fork_and_open_files/write_conflict.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

File.open "write_conflict.out", "w" do |file|
  file.puts "I'm the parent, #{Process.pid}."
  child_pid = fork
  if child_pid.nil?
    file.puts "I'm the child, #{Process.pid}."
  else
    Process::wait(child_pid)
    if $?.success?
      file.puts "Child ok."
    else
      file.puts "Child unhappy."
    end
  end
end

{% endhighlight %}

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
