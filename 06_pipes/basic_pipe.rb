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
raise "Unhappy child, its exitvalue was #{$?.exitstatus}" unless $?.success?


