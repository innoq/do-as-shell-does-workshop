#!/usr/bin/env ruby

$stderr.puts "I'm #{Process::pid}."

child_pid = fork

$stderr.puts "I have #{child_pid.inspect} " +
             "and I'm #{Process::pid}."
