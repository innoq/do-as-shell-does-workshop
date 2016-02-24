#!/usr/bin/env ruby

$stderr.puts "I am #{Process::pid} about to call exec."

# Replace this script with an invocation of ps:
exec 'ps', 'f', 'T'
# Use 'ps', '-j', '-T' on Mac

# This should never get executed:
raise "Exec did not work out."
