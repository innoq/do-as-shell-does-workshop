#!/usr/bin/env ruby

puts "I'm #{Process::pid}."

f = fork
puts "I have #{f.inspect} and I'm #{Process::pid}"

if f
  puts "Waiting for #{f} from #{Process::pid}"
  Process::wait(f)
  puts "Done waiting for #{f} from #{Process::pid}: #{$?.pid} has #{$?.exitstatus}."
else
  puts "I'm #{Process::pid} about to exit with 39."
  exit 39
end
