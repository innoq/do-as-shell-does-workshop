#!/usr/bin/env ruby

child_pid = fork

if child_pid.nil?
  # I am the child. I do nothing in particular.
  Signal.trap 'INT' do
    $stderr.puts "I'm a child " +
                 "unwilling to be interrupted."
  end
  sleep 2
  exit 0
end

sleep 0.1 # Give the child time to run the Signal.trap.
Process.kill 'SIGINT', child_pid

Process.wait child_pid

if $?.success?
  $stderr.puts "Child exited successfully."
elsif $?.signaled?
  $stderr.puts "Child terminated by signal " +
               "#{Signal.signame($?.termsig)}."
else
  $stderr.puts "Child exit status #{$?.exitstatus}."
end
