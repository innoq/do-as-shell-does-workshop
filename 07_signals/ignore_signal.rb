#!/usr/bin/env ruby

# Ignoring signals
child_pid = fork

if child_pid.nil?
  Signal.trap 'INT', 'IGNORE'
  # Ignoring signals survives exec:
  Process.exec '/bin/sleep', '2'
  # Never get here.
end

# Child process needs a moment to start the sleep,
# otherwise the signal is lost(!):
sleep 0.1

$stderr.puts "Sending INT to #{child_pid}"
Process.kill('INT', child_pid)

Process.wait child_pid

if $?.signaled?
  $stderr.puts "Child terminated by signal #{Signal.signame($?.termsig)}."
elsif $?.success?
  $stderr.puts "Child exited successfully."
else
  $stderr.puts "Child exit status #{$?.exitstatus}."
end
