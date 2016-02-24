#!/usr/bin/env ruby

$stderr.puts "About to call, says #{Process::pid}."

system('./fail_via_exception.rb')

$stderr.puts "Done calling."



