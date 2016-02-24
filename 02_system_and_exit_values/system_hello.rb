#!/usr/bin/env ruby

$stderr.puts "About to call hello, I'm process #{Process::pid}."

system('./hello.rb')

$stderr.puts "Done calling hello, back in #{Process::pid}."



