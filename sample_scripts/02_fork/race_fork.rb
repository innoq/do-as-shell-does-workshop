#!/usr/bin/env ruby

puts "I'm #{Process::pid}."

f = fork
puts "I have #{f.inspect} and I'm #{Process::pid}."
