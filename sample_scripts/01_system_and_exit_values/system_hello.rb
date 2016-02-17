#!/usr/bin/env ruby

puts "About to call hello, I'm process #{Process::pid}."

system('./hello.rb')

puts "Done calling hello, back in #{Process::pid}."



