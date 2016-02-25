---
title: pipes
layout: section
previous_section: 05_fork_and_open_files.html
next_section: 07_signals.html
---
# Pipes

A pipe is something one process writes to and another process
reads.  It has two ends: One end can be written to, the other end
can be read from.

File `06_pipes/basic_pipe.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

readMe, writeMe = IO.pipe

# Parent writes to child

child_pid = fork
if child_pid.nil?
  # child process
  writeMe.close
  readMe.each_line do |line|
    $stderr.puts "child read: #{line}"
  end
  exit 0
end

# parent process
readMe.close
(1 .. 20).each do |i|
  $stderr.puts "parent writes #{i}"
  writeMe.write "This is the wonderful line #{i}\n"
  # sleep 0.01
end
writeMe.close

Process.wait child_pid
raise "ERROR child: #{$?.exitstatus}" unless $?.success?


{% endhighlight %}
Output is:

```
parent writes 1
parent writes 2
parent writes 3
parent writes 4
parent writes 5
parent writes 6
parent writes 7
parent writes 8
parent writes 9
parent writes 10
parent writes 11
parent writes 12
parent writes 13
parent writes 14
parent writes 15
child read: This is the wonderful line 1
child read: This is the wonderful line 2
parent writes 16
child read: This is the wonderful line 3
child read: This is the wonderful line 4
child read: This is the wonderful line 5
child read: This is the wonderful line 6
parent writes 17child read: This is the wonderful line 7

child read: This is the wonderful line 8
child read: This is the wonderful line 9
child read: This is the wonderful line 10
parent writes 18
child read: This is the wonderful line 11
child read: This is the wonderful line 12
parent writes 19child read: This is the wonderful line 13

child read: This is the wonderful line 14
child read: This is the wonderful line 15
child read: This is the wonderful line 16
parent writes 20
child read: This is the wonderful line 17
child read: This is the wonderful line 18
child read: This is the wonderful line 19
child read: This is the wonderful line 20

```

Programm ran successfully.


The reader sees "EOF" if the sender (more precisely: *all*
senders) have closed the writing end of the pipe.

Behind the scenes, a pipe is an extremely fast I/O mechanism.  In
Linux, it is backed by a buffer of 65536 bytes (can be changed
for a particular pipe).  Don't know how big it is for Mac.

File `06_pipes/fast_pipe.rb`:

{% highlight ruby %}
#!/usr/bin/env ruby

readMe, writeMe = IO.pipe

# Parent writes, child reads
# in chunks of 65536 bytes
child_pid = fork
if child_pid.nil?
  # child process
  writeMe.close
  read_start_time = Time.now
  total_read = 0
  while buf = readMe.read(65536)
    total_read += buf.length
  end
  readMe.close
  read_end_time = Time.now
  d = read_end_time - read_start_time
  $stderr.puts "Total read: #{total_read} bytes in #{d} s,\n" +
       "#{total_read / 1024.0 / 1024.0 / d} MByte/s."
  exit 0
end

# parent process
readMe.close

# Produce a string 2 ** 16 = 65536 byte long
junk = " "
(1 .. 16).each do |i|
  junk = "#{junk}#{junk}"
end
$stderr.puts "junk is #{junk.length} byte long"

(1 .. 100000).each do |i|
  writeMe.write junk
end
writeMe.close

Process.wait child_pid
raise "ERROR child: #{$?.exitstatus}" unless $?.success?


{% endhighlight %}
Output is:

```
junk is 65536 byte long
Total read: 6553600000 bytes in 2.288141863 s,
2731.473996898767 MByte/s.

```

Programm ran successfully.


## Exercises

* Temporarily remove the closing of the pipe's write end from the
  reader in one of the sample programs.  What happens?

* Reorganize the program such that the sender is the child and
  the parent reads.  Let the parent close the reading end after
  reading 120000 bytes, while the child wants to write 200000
  bytes.  What happens?

* Devise a program that determines the buffer space provided by a
  pipe.  (Hint: Defer reading.  Measure the time required for
  writing.)
