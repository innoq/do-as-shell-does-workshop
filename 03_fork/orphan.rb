#!/usr/bin/env ruby

$stderr.puts "I'm #{Process::pid}."

child_pid = fork

if child_pid.nil?
  sleep 0.1
  system 'ps', 'f', 'l', 'T' or raise "Couldn't ps"
end

exit 0


