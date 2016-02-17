#!/usr/bin/env ruby

puts "About to call, says #{Process::pid}."

system('./fail_via_exception.rb')

puts "Done calling."



