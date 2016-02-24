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
