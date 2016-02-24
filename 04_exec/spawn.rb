#!/usr/bin/env ruby

$stderr.puts "I am #{Process::pid} about to call spawn."

child_pid = spawn 'ps', 'f', 'T'

Process::wait(child_pid)
if not $?.success?
  raise "ps ran into error, exit sstatus #{$?.exitstatus}."
end

