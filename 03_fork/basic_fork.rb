#!/usr/bin/env ruby

$stderr.puts "I'm #{Process::pid}."

pid = fork
$stderr.puts "I have #{pid.inspect} and I'm #{Process::pid}"

if pid.nil?
  # I'm the child
  $stderr.puts "I'm #{Process::pid} about to exit with 39."
  exit 39
else
  # I'm the parent
  $stderr.puts "Waiting for #{pid} from #{Process::pid}"
  Process::wait(pid)
  
  # process $? same way as we are used to by now:
  $stderr.puts "Done waiting for #{pid} from #{Process::pid}:" +
               " #{$?.pid} has #{$?.exitstatus}."
end
