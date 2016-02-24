#!/usr/bin/env ruby

$stderr.puts "I'm #{Process::pid}."

child_pid = fork
$stderr.puts "#{Process::pid} has #{child_pid.inspect}"

if child_pid.nil?
  # I'm the child
  $stderr.puts "#{Process::pid} about to exit 39."
  exit 39
else
  # I'm the parent
  $stderr.puts "#{Process::pid} waits for #{child_pid}"
  Process::wait child_pid
  
  $stderr.puts "#{Process::pid} reaped #{child_pid}:" +
               " #{$?.pid} has #{$?.exitstatus}."
end
