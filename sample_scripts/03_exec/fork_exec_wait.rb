#!/usr/bin/env ruby

puts "I am #{Process::pid} about to call fork and exec."

child_pid = fork

if child_pid.nil?
  exec 'ps', 'f', 'T'
  # Use 'ps', '-j', '-T' on Mac
  
  # This should never get executed:
  raise "Exec did not work out."
else
  Process::wait(child_pid)
  if not $?.success?
    raise "ps ran into error, exit sstatus #{$?.exitstatus}."
  end
end
