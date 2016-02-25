#!/usr/bin/env ruby

$stderr.puts "About to call from #{Process::pid}."

system('./fail_via_exception.rb') or \
  raise "ERROR in system"

$stderr.puts "Done calling."

