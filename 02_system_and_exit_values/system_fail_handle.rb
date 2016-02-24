#!/usr/bin/env ruby

$stderr.puts "About to call from #{Process::pid}."

system('./fail_via_exception.rb') or raise "Something failed down there."

$stderr.puts "Done calling."



