#!/usr/bin/env ruby

child_pid = fork

if child_pid.nil?
  # I am the child. I do nothing in particular.
  sleep 2
  exit 0
end

Process.kill 'INT', child_pid

Process.wait child_pid

if $?.success?
  puts "Child exited successfully."
elsif $?.signaled?
  puts "Child terminated by #{Signal.signame($?.termsig)}."
else
  puts "Child exit status #{$?.exitstatus}."
end
