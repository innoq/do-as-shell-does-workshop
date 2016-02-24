#!/usr/bin/env ruby

readMe, writeMe = IO.pipe

# Parent writes to child in chunks of 65536 bytes
child_pid = fork
if child_pid.nil?
  # child process
  writeMe.close
  sleep 2
  total_read = 0
  while buf = readMe.read(65536)
    total_read += buf.length
  end
  readMe.close
  exit 0
end

# parent process
readMe.close
(1 .. 10000000).each do |i|
  write_start_time = Time.now
  writeMe.write(" ")
  writeMe.flush
  write_end_time = Time.now
  if 0.1 < write_end_time - write_start_time
    $stderr.puts "#{i-1} byte could be written quickly."
    break
  end
end
writeMe.close

Process.wait child_pid
raise "Unhappy child, its exitvalue was #{$?.exitstatus}" unless $?.success?


