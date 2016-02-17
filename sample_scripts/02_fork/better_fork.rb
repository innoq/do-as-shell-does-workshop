#!/usr/bin/env ruby

puts "I'm #{Process::pid}.\n"

f = fork

Process.wait(f) unless f.nil?

puts "\nI have #{f.inspect} and I'm #{Process::pid}."
system 'ps', 'f', 'T' or raise "Couldn't system"

