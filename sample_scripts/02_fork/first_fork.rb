#!/usr/bin/env ruby

puts "I'm #{Process::pid}."

whatsthis = fork

puts "I have #{whatsthis.inspect} and I'm #{Process::pid}."
