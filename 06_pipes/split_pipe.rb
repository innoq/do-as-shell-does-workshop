#!/usr/bin/env ruby

# Produce a string 2 ** 16 = 65536 byte long
junk = "x"
(1 .. 11).each do |i|
  junk = "#{junk}#{junk}#{junk}"
end
$stderr.puts "junk is #{junk.length} byte long"

readMe, writeMe = IO.pipe

# Parent writes to child in chunks of 65536 bytes
child_pid = fork
if child_pid.nil?
  # child process
  writeMe.close
  read_start_time = Time.now
  total_read = 0
  while buf = readMe.read(75361)
    total_read += buf.length
  end
  readMe.close
  read_end_time = Time.now
  d = read_end_time - read_start_time
  $stderr.puts "Total read: #{total_read} bytes in #{d} s, " +
       "#{total_read / 1024.0 / 1024.0 / d} MByte/s."
  exit 0
end

# parent process
readMe.close
(1 .. 40000).each do |i|
  writeMe.write junk
end
writeMe.close

Process.wait child_pid
raise "Unhappy child, its exitvalue was #{$?.exitstatus}" unless $?.success?


