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

writeMe.puts "\0\t\nhello\vworld.\n"
writeMe.close

Process.wait child_pid
raise "od had a problem" unless $?.success?
