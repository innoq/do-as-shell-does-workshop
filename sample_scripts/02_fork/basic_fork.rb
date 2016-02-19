#!/usr/bin/env ruby

puts "I'm #{Process::pid}."

pid = fork
puts "I have #{pid.inspect} and I'm #{Process::pid}"

if pid.nil?
  # I'm the child
  puts "I'm #{Process::pid} about to exit with 39."
  exit 39
else
  # I'm the parent
  puts "Waiting for #{pid} from #{Process::pid}"
  Process::wait(pid)
  
  # process $? same as we are used to:
  puts "Done waiting for #{pid} from #{Process::pid}: #{$?.pid} has #{$?.exitstatus}."
end
