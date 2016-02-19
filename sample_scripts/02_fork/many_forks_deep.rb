#!/usr/bin/env ruby

puts "I'm #{Process::pid}."

wanted_fork_count = 15

while 0 < wanted_fork_count
  child_pid = fork
  if child_pid.nil?
    # I'm the child
    wanted_fork_count -= 1
    if 0 == wanted_fork_count
      system 'ps', 'f', 'T' or raise "Couldn't system"
    end
  else
    # I'm the parent
    wanted_fork_count = 0
    Process::wait child_pid
  end
end
