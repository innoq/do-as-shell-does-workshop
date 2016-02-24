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


