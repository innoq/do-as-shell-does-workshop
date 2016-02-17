#!/usr/bin/env ruby

puts "About to call from #{Process::pid}."

system('./fail_via_exception.rb') or raise "Something failed down there."

puts "Done calling."



